terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    # WARN: Do not forget to set correct value for the particular module/folder!
    key = "global/s3/logging/terraform.tfstate"
  }
}

provider "yandex" {
  token     = var.iam_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}


data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "terraform-states-b1gcj63q69dgi7jup4i5"
    key    = "global/iam/terraform.tfstate"
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

# https://terraform-provider.yandexcloud.net/Resources/storage_bucket
# https://yandex.cloud/en-ru/docs/storage/operations/buckets/create#tf_1
resource "yandex_storage_bucket" "bucket" {
  access_key            = data.terraform_remote_state.iam.outputs.s3-sak["s3-admin"].access_key
  secret_key            = data.terraform_remote_state.iam.outputs.s3-sak["s3-admin"].secret_key
  bucket                = "logging-${var.cloud_id}-1"
  max_size              = "21474836480" # Max bucket size threshold. Set to 20GB.
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
