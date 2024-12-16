# https://terraform-provider.yandexcloud.net/Resources/vpc_address
resource "yandex_vpc_address" "addr" {
  name        = "addr-1"
  description = "Static IP address"
  folder_id   = var.folder_id

  external_ipv4_address {
    zone_id                  = var.zone
    ddos_protection_provider = "qrator"
  }
}


