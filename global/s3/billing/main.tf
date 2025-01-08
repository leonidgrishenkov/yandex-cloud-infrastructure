terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    # WARN: Do not forget to set correct value for the particular module/folder!
    key = "global/s3/billing/terraform.tfstate"
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

resource "yandex_storage_bucket" "bucket" {
  access_key            = data.terraform_remote_state.iam.outputs.s3-admin-access-key
  secret_key            = data.terraform_remote_state.iam.outputs.s3-admin-secret-key
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

  # Enable bucket logging.
  # https://yandex.cloud/en-ru/docs/storage/operations/buckets/enable-logging
  logging {
    target_bucket = "logging-b1gcj63q69dgi7jup4i5"
    target_prefix = "billing/"
  }

  # Define lifecycle rules.
  # https://yandex.cloud/en-ru/docs/storage/operations/buckets/lifecycles
  # STANDARD -> COLD after 30 days.
  lifecycle_rule {
    id      = "to_cold_after_30d"
    enabled = true
    transition {
      days          = 30
      storage_class = "COLD"
    }
  }
  # COLD -> ICE after 90 days.
  lifecycle_rule {
    id      = "to_ice_after_90d"
    enabled = true
    transition {
      days          = 90
      storage_class = "ICE"
    }
  }
}
