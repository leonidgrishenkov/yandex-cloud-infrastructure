terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    # WARN: Do not forget to set correct value for the particular module/folder!
    key = "dev/services/compute-1/terraform.tfstate"
  }
}

provider "yandex" {
  token     = var.iam_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-states-b1gcj63q69dgi7jup4i5"
    key    = "dev/vpc/terraform.tfstate"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    access_key                  = var.s3_access_key
    secret_key                  = var.s3_secret_key
    region                      = "ru-central1"
    encrypt                     = false
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

data "yandex_compute_image" "image" {
  family = "ubuntu-2204-lts"
}

resource "random_password" "yc-user-passwd" {
  length  = 40
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource "yandex_compute_instance" "dev-compute-1" {
  name        = "dev-compute-1"
  hostname    = "dev-compute-1"
  platform_id = "standard-v3"
  zone        = var.zone
  folder_id   = var.folder_id
  labels = {
    env  = "dev"
    type = "personal"
  }

  resources {
    cores         = 4
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type     = "network-hdd"
      size     = 100
    }
    auto_delete = true
  }

  network_interface {
    subnet_id          = data.terraform_remote_state.vpc.outputs.dev-vpc-1-subnet-a-id
    security_group_ids = data.terraform_remote_state.vpc.outputs.dev-vpc-1-sg-ids
    nat                = true
    ipv4               = true
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yaml",
      {
        yc-user-passwd    = random_password.yc-user-passwd.bcrypt_hash,
        yc-user-ssh-key   = file("~/.ssh/dev-hosts.pub"),
    })
  }
}
