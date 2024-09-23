# Creating a service account.
# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "k8s-sa" {
  name      = "k8s-sa"
  folder_id = var.folder_id
}

# Assign "editor" role to service account.
# https://terraform-provider.yandexcloud.net/Resources/resourcemanager_folder_iam_binding
resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
}
# Assign "container-registry.images.puller" role to service account.
resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
  ]
}
