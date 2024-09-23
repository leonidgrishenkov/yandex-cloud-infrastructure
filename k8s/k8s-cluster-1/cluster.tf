locals {
  k8s_version = "1.29"
}

# Configuration for k8s Cluster and master node.
# https://terraform-provider.yandexcloud.net/Resources/kubernetes_cluster
resource "yandex_kubernetes_cluster" "k8s-cluster" {
  name        = "k8s-cluster-1"
  description = "Kubernetes Cluster 1"
  network_id  = var.network_id

  # cluster_ipv4_range = "10.96.0.0/16"
  # service_ipv4_range = "10.112.0.0/16"

  release_channel = "STABLE"

  # Service account to be used for provisioning Compute Cloud and VPC resources
  # for Kubernetes cluster. Selected service account should have edit role on the folder where the Kubernetes
  # cluster will be located and on the folder where selected network resides.
  service_account_id = yandex_iam_service_account.k8s-sa.id
  # Service account to be used by the worker nodes of the Kubernetes cluster
  # to access Container Registry or to push node logs and metrics.
  node_service_account_id = yandex_iam_service_account.k8s-sa.id
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.images-puller
  ]


  # Kubernetes master configuration.
  master {
    version   = local.k8s_version
    public_ip = true
    master_location {
      zone      = var.zone
      subnet_id = var.subnet_id
    }

    security_group_ids = [
      yandex_vpc_security_group.k8s-main-sg.id,
      yandex_vpc_security_group.k8s-master-whitelist.id
    ]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "03:00"
        duration   = "3h"
      }
    }
  }
}

# Configuration for k8s cluster node groups.
# https://terraform-provider.yandexcloud.net/Resources/kubernetes_node_group
resource "yandex_kubernetes_node_group" "nodes-group" {
  cluster_id  = yandex_kubernetes_cluster.k8s-cluster.id
  name        = "nodes-group-1"
  version     = local.k8s_version
  description = "Node group for Kubernetes cluster 1"

  instance_template {
    platform_id = "standard-v3"
    metadata = {
      ssh-keys = "admin:${file("~/.ssh/dev-hosts.pub")}"
    }
    network_interface {
      nat        = true
      subnet_ids = [var.subnet_id]
      security_group_ids = [
        yandex_vpc_security_group.k8s-main-sg.id,
        yandex_vpc_security_group.k8s-nodes-ssh-access.id,
        yandex_vpc_security_group.k8s-public-services.id
      ]
    }
    resources {
      memory = 4
      cores  = 4
    }
    boot_disk {
      type = "network-hdd"
      size = 64
    }
    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    auto_scale {
      min     = 1
      max     = 10
      initial = 1
    }
  }
  allocation_policy {
    location {
      zone = var.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      start_time = "03:00"
      duration   = "3h"
    }
  }
}
