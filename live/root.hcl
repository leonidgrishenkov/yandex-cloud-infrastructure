remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = get_env("YC_S3_TF_STATES_BUCKET")
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "ru-central1"
    endpoints = {
      s3 = get_env("YC_S3_ENDPOINT") 
    }
    encrypt                     = false
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  terraform {
    required_providers {
      yandex = {
        source = "yandex-cloud/yandex"
      }
    }
    required_version = ">= 0.13"
  }

  provider "yandex" {
    token     = var.iam_token
    cloud_id  = var.cloud_id
    folder_id = var.folder_id
    zone      = var.zone
  }
  EOF
}

inputs = {
  cloud_id      = get_env("YC_CLOUD_ID")
  folder_id     = get_env("YC_FOLDER_ID")
  iam_token     = get_env("YC_IAM_TOKEN")
  zone          = "ru-central1-a"
}
