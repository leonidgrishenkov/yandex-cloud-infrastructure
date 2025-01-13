terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    # WARN: Do not forget to set correct value for the particular module/folder!
    key = "dev/vpc/terraform.tfstate"
  }
}

provider "yandex" {
  token     = var.iam_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_vpc_network" "dev-vpc-1" {
  name      = "dev-vpc-1"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "dev-vpc-1-subnet-a" {
  name           = "dev-vpc-1-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.dev-vpc-1.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "dev-vpc-1-subnet-b" {
  name           = "dev-vpc-1-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.dev-vpc-1.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}
