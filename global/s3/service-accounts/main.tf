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

# Creating a service account.
# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "storage-admin" {
  name        = "storage-admin"
  description = "Object Storage administrator"
  folder_id   = var.yc-folder-id
}

# Assigning role to the service account.
# https://terraform-provider.yandexcloud.net/Resources/resourcemanager_folder_iam_binding
resource "yandex_resourcemanager_folder_iam_binding" "storage-admin" {
  folder_id = var.yc-folder-id

  role = "storage.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.storage-admin.id}"
  ]
}

data "yandex_iam_service_account" "storage-admin" {
  service_account_id = yandex_iam_service_account.storage-admin.id
}

output "storage-admin-id" {
  value = data.yandex_iam_service_account.storage-admin.id
}
