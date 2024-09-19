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

# https://terraform-provider.yandexcloud.net/Resources/container_registry
resource "yandex_container_registry" "personal-registry-1" {
  name      = "personal-registry-1"
  folder_id = var.yc-folder-id

  labels = {
    type = "personal"
  }
}

# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "personal-container-registry-admin" {
  name        = "personal-container-registry-admin"
  description = "Container registry administrator"
  folder_id   = var.yc-folder-id
}

# https://terraform-provider.yandexcloud.net/Resources/resourcemanager_folder_iam_binding
resource "yandex_resourcemanager_folder_iam_binding" "container-registry-admin" {
  folder_id = var.yc-folder-id

  role = "container-registry.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.personal-container-registry-admin.id}"
  ]
}

data "yandex_container_registry" "personal-registry-1" {
  registry_id = yandex_container_registry.personal-registry-1.id
}
data "yandex_iam_service_account" "personal-container-registry-admin" {
  service_account_id = yandex_iam_service_account.personal-container-registry-admin.id
}

output "personal-registry-1-id" {
  value = data.yandex_container_registry.personal-registry-1.id
}
output "personal-container-registry-admin-id" {
  value = data.yandex_iam_service_account.personal-container-registry-admin.id
}
