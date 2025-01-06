# Creating a service account.
# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "terraform-sa" {
  name        = "terraform-sa"
  description = "Terraform service account for cloud resources editing"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.folder_id
  # https://yandex.cloud/ru/docs/iam/roles-reference#editor
  role = "editor"
  member = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "s3-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform-sa.id}"
}
