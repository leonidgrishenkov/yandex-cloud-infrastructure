# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "sa" {
  name        = "dev-registry-1-admin"
  description = "Container registry administrator for `dev-registry-1` registry."
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

data "yandex_iam_service_account" "sa" {
  service_account_id = yandex_iam_service_account.sa.id
}
