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

# Creating a static access key.
resource "yandex_iam_service_account_static_access_key" "storage-admin-static-key" {
  service_account_id = var.yc-storage-admin-id
  description        = "Static access key for object storage administator"
}

# Creating a bucket using the key.
# https://terraform-provider.yandexcloud.net/Resources/storage_bucket
# https://yandex.cloud/en-ru/docs/storage/operations/buckets/create#tf_1
resource "yandex_storage_bucket" "yandex-cloud-billing" {
  access_key            = yandex_iam_service_account_static_access_key.storage-admin-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.storage-admin-static-key.secret_key
  bucket                = "yandex-cloud-billing"
  max_size              = "5368709120" # Max bucket size threshold. Set to 5GB.
  default_storage_class = "COLD"
  acl                   = "private"
  folder_id             = var.yc-folder-id

  versioning {
    enabled = false
  }
  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
}
