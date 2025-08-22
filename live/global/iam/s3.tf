locals {
  s3-sa = [
    {
      name = "s3-viewer"
      role = "storage.viewer"
    },
    {
      name = "s3-uploader"
      role = "storage.uploader"
    },
    {
      name = "s3-admin"
      role = "storage.admin"
    },
  ]
}

# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "s3-sa" {
  for_each = {
    for sa in local.s3-sa : sa.name => sa
  }

  name      = each.value.name
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "s3-binding" {
  for_each = {
    for sa in local.s3-sa : sa.name => sa
  }

  role      = each.value.role
  folder_id = var.folder_id

  members = [
    "serviceAccount:${yandex_iam_service_account.s3-sa[each.key].id}"
  ]
}

resource "yandex_iam_service_account_static_access_key" "s3-sak" {
  for_each = {
    for sa in local.s3-sa : sa.name => sa
  }

  service_account_id = yandex_iam_service_account.s3-sa[each.key].id
}
