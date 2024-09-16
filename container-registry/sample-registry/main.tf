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
resource "yandex_container_registry" "registry-1" {
  name      = "registry-1"
  folder_id = var.yc-folder-id

  labels = {
    my-label = "terraform"
  }
}

# https://terraform-provider.yandexcloud.net/Resources/container_registry_iam_binding
# resource "yandex_container_registry_iam_binding" "puller" {
#   registry_id = yandex_container_registry.your-registry.id
#   role        = "container-registry.images.puller"

#   members = [
#     "serviceAccount:allUsers",
#   ]
# }

data "yandex_container_registry" "registry-1" {
  registry_id = yandex_container_registry.registry-1.id
}

output "registry-1-id" {
  value = data.yandex_container_registry.registry-1.id
}
