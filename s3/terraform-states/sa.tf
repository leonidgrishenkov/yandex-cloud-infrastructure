# Creating a service account.
# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "terraform-states-admin" {
  name        = "terraform-states-admin"
  description = "Administrator of S3 bucket: terraform-states"
  folder_id   = var.folder_id
}

# Assigning role to the service account.
# https://terraform-provider.yandexcloud.net/Resources/resourcemanager_folder_iam_binding
resource "yandex_resourcemanager_folder_iam_binding" "terraform-states-admin" {
  folder_id = var.folder_id

  role = "storage.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.terraform-states-admin.id}"
  ]
}

