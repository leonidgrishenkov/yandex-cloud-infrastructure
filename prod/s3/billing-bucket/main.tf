terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    # WARN: Do not forget to set correct value for the particular module/folder!
    key = "prod/s3/billing-bucket/terraform.tfstate"
  }
}

provider "yandex" {
  token     = var.iam_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}


# https://terraform-provider.yandexcloud.net/Resources/storage_bucket
# https://yandex.cloud/en-ru/docs/storage/operations/buckets/create#tf_1
resource "yandex_storage_bucket" "bucket" {
  access_key            = yandex_iam_service_account_static_access_key.admin-sa-sak.access_key
  secret_key            = yandex_iam_service_account_static_access_key.admin-sa-sak.secret_key
  bucket                = "billing-${var.cloud_id}"
  max_size              = "5368709120" # Max bucket size threshold. Set to 5GB.
  default_storage_class = "STANDARD"
  acl                   = "private"
  folder_id             = var.folder_id

  versioning {
    enabled = false
  }
  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }
}
