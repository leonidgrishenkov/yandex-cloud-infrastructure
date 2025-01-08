# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "viewer-sa" {
  name = "billing-viewer"
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
  name = "billing-uploader"
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
  name = "billing-admin"
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

