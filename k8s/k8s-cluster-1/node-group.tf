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
