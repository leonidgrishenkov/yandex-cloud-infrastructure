resource "yandex_vpc_network" "network" {
  name      = "dev-compute-1-vpc"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "dev-compute-1-vpc-subnet-a"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}
