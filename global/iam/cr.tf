locals {
  cr-sa = [
    {
      name = "cr-viewer"
      role = "container-registry.viewer"
    },
    {
      name = "cr-admin"
      role = "container-registry.admin"
    },
    {
      name = "cr-pusher"
      role = "container-registry.images.pusher"
    },
  ]
}

resource "yandex_iam_service_account" "cr-sa" {
  for_each = {
    for sa in local.cr-sa : sa.name => sa
  }

  name      = each.value.name
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "cr-binding" {
  for_each = {
    for sa in local.cr-sa : sa.name => sa
  }

  role      = each.value.role
  folder_id = var.folder_id

  members = [
    "serviceAccount:${yandex_iam_service_account.cr-sa[each.key].id}"
  ]
}
