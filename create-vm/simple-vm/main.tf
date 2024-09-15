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
  zone      = "ru-central1-a"
}

resource "yandex_compute_disk" "boot-disk-01" {
  name     = "boot-disk-01"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = var.yc-image-id
}

resource "yandex_compute_instance" "vm-from-terraform-01" {
  name        = "vm-from-terraform-01"
  hostname    = "vm-from-terraform-01"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 100
  }

  boot_disk {
    disk_id     = yandex_compute_disk.boot-disk-01.id
    auto_delete = true
  }

  network_interface {
    subnet_id = "e9bk25s0hddagr9a5st5"
    security_group_ids = ["enpbtrqsm1fe39b0gtf0"]
    nat       = true
    ipv4      = true
  }

  metadata = {
    user-data = "${file("./cloud-init.txt")}"
  }
}
