locals {
  zone        = "ru-central1-a"
  network_id  = var.yc-network-id
  subnet_id   = var.yc-subnet-id
  k8s_version = "1.29"
}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.yc-iam-token
  cloud_id  = var.yc-cloud-id
  folder_id = var.yc-folder-id
  zone      = local.zone
}


resource "yandex_vpc_security_group" "k8s-main-sg" {
  name        = "k8s-main-sg"
  description = "Правила группы обеспечивают базовую работоспособность кластера. Должны быть применены к кластеру и группам узлов."
  network_id  = local.network_id
  ingress {
    protocol          = "TCP"
    description       = "Правило разрешает проверки доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Правило разрешает взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "Правило разрешает взаимодействие под-под и сервис-сервис. Укажите подсети вашего кластера и сервисов."
    v4_cidr_blocks = ["10.96.0.0/16", "10.112.0.0/16"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "ICMP"
    description    = "Правило разрешает отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8", "192.168.0.0/16"]
  }
  egress {
    protocol       = "ANY"
    description    = "Правило разрешает весь исходящий трафик. Узлы могут связаться с Yandex Container Registry, Object Storage, Docker Hub и т. д."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "k8s-public-services" {
  name        = "k8s-public-services"
  description = "Правила группы разрешают подключение к сервисам из интернета. Примените правила только для групп узлов."
  network_id  = local.network_id

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает входящий трафик из интернета на диапазон портов NodePort. Добавьте или измените порты на нужные вам."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

resource "yandex_vpc_security_group" "k8s-nodes-ssh-access" {
  name        = "k8s-nodes-ssh-access"
  description = "Правила группы разрешают подключение к узлам кластера по SSH. Примените правила только для групп узлов."
  network_id  = local.network_id

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к узлам по SSH с указанных IP-адресов."
    v4_cidr_blocks = ["185.61.78.47/32"]
    port           = 22
  }
}

resource "yandex_vpc_security_group" "k8s-master-whitelist" {
  name        = "k8s-master-whitelist"
  description = "Правила группы разрешают доступ к API Kubernetes из интернета. Примените правила только к кластеру."
  network_id  = local.network_id

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к API Kubernetes через порт 6443 из указанной сети."
    v4_cidr_blocks = ["185.61.78.47/32"]
    port           = 6443
  }

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к API Kubernetes через порт 443 из указанной сети."
    v4_cidr_blocks = ["185.61.78.47/32"]
    port           = 443
  }
}


# Creating a service account.
# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "editor" {
  name        = "editor"
  description = "Folder editor"
  folder_id   = var.yc-folder-id
}
resource "yandex_iam_service_account" "node-sa-1" {
  name        = "node-sa-1"
  description = "SA for k8s nodes"
  folder_id   = var.yc-folder-id
}

# Assigning role to the service account.
# https://terraform-provider.yandexcloud.net/Resources/resourcemanager_folder_iam_binding
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc-folder-id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.editor.id}"
  ]
}
resource "yandex_resourcemanager_folder_iam_binding" "node-sa-1" {
  folder_id = var.yc-folder-id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.node-sa-1.id}"
  ]
}

# Configuration for k8s Cluster and master node.
# https://terraform-provider.yandexcloud.net/Resources/kubernetes_cluster
resource "yandex_kubernetes_cluster" "k8s-cluster-1" {
  name        = "k8s-cluster-1"
  description = "Kubernetes Cluster 1"
  network_id  = local.network_id

  cluster_ipv4_range = "10.96.0.0/16"
  service_ipv4_range = "10.112.0.0/16"

  release_channel = "STABLE"

  # Service account to be used for provisioning Compute Cloud and VPC resources
  # for Kubernetes cluster. Selected service account should have edit role on the folder where the Kubernetes
  # cluster will be located and on the folder where selected network resides.
  service_account_id = yandex_iam_service_account.editor.id
  # Service account to be used by the worker nodes of the Kubernetes cluster
  # to access Container Registry or to push node logs and metrics.
  node_service_account_id = yandex_iam_service_account.node-sa-1.id


  # Kubernetes master configuration options.
  master {
    version   = local.k8s_version
    public_ip = true
    zonal {
      zone      = local.zone
      subnet_id = local.subnet_id
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
resource "yandex_kubernetes_node_group" "nodes-group-1" {
  cluster_id = yandex_kubernetes_cluster.k8s-cluster-1.id
  name       = "nodes-group-1"
  version    = local.k8s_version

  instance_template {
    platform_id = "standard-v3"
    network_interface {
      nat        = true
      subnet_ids = [local.subnet_id, ]
      security_group_ids = [
        yandex_vpc_security_group.k8s-main-sg.id,
        yandex_vpc_security_group.k8s-nodes-ssh-access.id,
        yandex_vpc_security_group.k8s-public-services.id
      ]
    }
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 20
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
      zone      = local.zone
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
