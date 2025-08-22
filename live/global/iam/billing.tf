locals {
  billing-sa = [
    {
      name = "billing-viewer"
      role = "billing.accounts.viewer"
    },
  ]
}

# https://terraform-provider.yandexcloud.net/Resources/iam_service_account
resource "yandex_iam_service_account" "billing-sa" {
  for_each = {
    for sa in local.billing-sa : sa.name => sa
  }

  name      = each.value.name
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "billing-binding" {
  for_each = {
    for sa in local.billing-sa : sa.name => sa
  }

  role      = each.value.role
  folder_id = var.folder_id

  members = [
    "serviceAccount:${yandex_iam_service_account.billing-sa[each.key].id}"
  ]
}

resource "yandex_iam_service_account_key" "billing-sa-auth-key" {
  for_each = {
    for sa in yandex_iam_service_account.billing-sa : sa.name => sa.id
  }
  service_account_id = each.value
  key_algorithm      = "RSA_4096"
}
