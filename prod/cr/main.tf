# https://terraform-provider.yandexcloud.net/Resources/container_registry
resource "yandex_container_registry" "prod-cr-1" {
  name      = "prod-cr-1"
  folder_id = var.folder_id

  labels = {
    type = "personal"
    env = "prod"
  }
}

data "yandex_container_registry" "prod-cr-1" {
  registry_id = yandex_container_registry.prod-cr-1.id
}
