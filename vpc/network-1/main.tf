locals {
  zone = "ru-central1-a"
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

# https://terraform-provider.yandexcloud.net/Resources/vpc_network
resource "yandex_vpc_network" "network-1" {
  name        = "network-1"
  description = "Basic network"
  folder_id   = var.yc-folder-id
}

# https://terraform-provider.yandexcloud.net/Resources/vpc_subnet
resource "yandex_vpc_subnet" "network-1-subnet-a" {
  name           = "network-1-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "network-1-subnet-b" {
  name           = "network-1-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

# https://terraform-provider.yandexcloud.net/Resources/vpc_security_group
resource "yandex_vpc_security_group" "network-1-basic-sg-1" {
  name        = "network-1-basic-sg-1"
  description = "Basic Security group for network"
  network_id  = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "ANY"
    description    = "All traffic from my local IP"
    v4_cidr_blocks = ["185.61.78.47/32"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "All self traffic"
    predefined_target = "self_security_group"
  }

  egress {
    protocol       = "TCP"
    description    = "All HTTP traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  egress {
    protocol       = "TCP"
    description    = "All HTTPS traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
  egress {
    protocol          = "ANY"
    description       = "All self traffic"
    predefined_target = "self_security_group"
  }
}

# https://terraform-provider.yandexcloud.net/DataSources/datasource_vpc_network
data "yandex_vpc_network" "network-1" {
  network_id = yandex_vpc_network.network-1.id
  folder_id  = var.yc-folder-id
}
output "network-1-id" {
  value = data.yandex_vpc_network.network-1.id
}

# https://terraform-provider.yandexcloud.net/DataSources/datasource_vpc_subnet
# Output for `network-1-subnet-a`
data "yandex_vpc_subnet" "network-1-subnet-a" {
  subnet_id  = yandex_vpc_subnet.network-1-subnet-a.id
  folder_id  = var.yc-folder-id
}
output "network-1-subnet-a-id" {
  value = data.yandex_vpc_subnet.network-1-subnet-a.id
}

# Output for `network-1-subnet-b`
data "yandex_vpc_subnet" "network-1-subnet-b" {
  subnet_id  = yandex_vpc_subnet.network-1-subnet-b.id
  folder_id  = var.yc-folder-id
}
output "network-1-subnet-b-id" {
  value = data.yandex_vpc_subnet.network-1-subnet-b.id
}

