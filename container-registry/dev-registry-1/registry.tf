# https://terraform-provider.yandexcloud.net/Resources/container_registry
resource "yandex_container_registry" "registry" {
  name      = "dev-registry-1"
  folder_id = var.folder_id

  labels = {
    type = "personal"
    env = "dev"
  }
}

data "yandex_container_registry" "registry" {
  registry_id = yandex_container_registry.registry.id
}
