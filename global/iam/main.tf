terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    # WARN: Do not forget to set correct value for the particular module/folder!
    key = "global/iam/terraform.tfstate"
  }
}

provider "yandex" {
  token     = var.iam_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}



# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "viewer-sa" {
  name = "s3-viewer"
  folder_id = var.folder_id
}
resource "yandex_resourcemanager_folder_iam_binding" "viewer" {
  folder_id = var.folder_id
  role      = "storage.viewer"

  members = [
    "serviceAccount:${yandex_iam_service_account.viewer-sa.id}"
  ]
}
resource "yandex_iam_service_account_static_access_key" "viewer-sa-sak" {
  service_account_id = yandex_iam_service_account.viewer-sa.id
}


resource "yandex_iam_service_account" "uploader-sa" {
  name = "s3-uploader"
  folder_id = var.folder_id
}
resource "yandex_resourcemanager_folder_iam_binding" "uploader" {
  folder_id = var.folder_id
  role      = "storage.uploader"

  members = [
    "serviceAccount:${yandex_iam_service_account.uploader-sa.id}"
  ]
}
resource "yandex_iam_service_account_static_access_key" "uploader-sa-sak" {
  service_account_id = yandex_iam_service_account.uploader-sa.id
}


resource "yandex_iam_service_account" "admin-sa" {
  name = "s3-admin"
  folder_id = var.folder_id
}
resource "yandex_resourcemanager_folder_iam_binding" "admin" {
  folder_id = var.folder_id
  role      = "storage.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.admin-sa.id}"
  ]
}
resource "yandex_iam_service_account_static_access_key" "admin-sa-sak" {
  service_account_id = yandex_iam_service_account.admin-sa.id
}

