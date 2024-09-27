locals {
  k8s_version = "1.29"
}

# Configuration for k8s Cluster and master node.
# https://terraform-provider.yandexcloud.net/Resources/kubernetes_cluster
resource "yandex_kubernetes_cluster" "k8s-cluster" {
  name        = "k8s-cluster-1"
  description = "Kubernetes Cluster 1"
  network_id  = var.network_id

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

# https://terraform-provider.yandexcloud.net/DataSources/datasource_kubernetes_cluster
data "yandex_kubernetes_cluster" "k8s-cluster" {
    cluster_id = yandex_kubernetes_cluster.k8s-cluster.id
}
output "k8s-cluster-id" {
    value = data.yandex_kubernetes_cluster.k8s-cluster.id
}
