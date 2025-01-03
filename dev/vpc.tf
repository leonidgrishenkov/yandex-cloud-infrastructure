resource "yandex_vpc_network" "dev-vpc-1" {
  name      = "dev-vpc-1"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "dev-vpc-1-subnet-a" {
  name           = "dev-vpc-1-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.dev-vpc-1.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "dev-vpc-1-subnet-b" {
  name           = "dev-vpc-1-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.dev-vpc-1.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

# https://terraform-provider.yandexcloud.net/Resources/vpc_address
resource "yandex_vpc_address" "dev-addr-1" {
  name        = "dev-addr-1"
  description = "Static NAT IP address"
  folder_id   = var.folder_id

  external_ipv4_address {
    zone_id                  = var.zone
    # WARN: Be carefull with DDOS protection because some packets maybe lost due to MTU.
    # Learn more here: https://yandex.cloud/en-ru/docs/vpc/concepts/mtu-mss?utm_referrer=about%3Ablank
    # ddos_protection_provider = "qrator"
  }
}
