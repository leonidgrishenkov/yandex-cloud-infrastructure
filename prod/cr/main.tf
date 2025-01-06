terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    # WARN: Do not forget to set correct value for the particular module/folder!
    key = "prod/cr/terraform.tfstate"
  }
}

provider "yandex" {
  token     = var.iam_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}


# https://terraform-provider.yandexcloud.net/Resources/container_registry
resource "yandex_container_registry" "prod-cr-1" {
  name      = "prod-cr-1"
  folder_id = var.folder_id

  labels = {
    type = "personal"
    env = "prod"
  }
}

# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "sa" {
  name        = "prod-cr-1-admin"
  description = "Container registry administrator for the registry: prod-cr-1"
  folder_id   = var.folder_id
}

# https://terraform-provider.yandexcloud.net/Resources/resourcemanager_folder_iam_binding
resource "yandex_resourcemanager_folder_iam_binding" "iam_binding" {
  folder_id = var.folder_id

  role = "container-registry.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.sa.id}"
  ]
}
