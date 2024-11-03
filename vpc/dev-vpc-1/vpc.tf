resource "yandex_vpc_network" "vpc" {
  name      = "dev-vpc-1"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "subnet-a" {
  name           = "dev-vpc-1-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.0.0.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = "dev-vpc-1-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.1.0.0/24"]
}

data "yandex_vpc_subnet" "subnet-a" {
  subnet_id = yandex_vpc_subnet.subnet-a.id
}
data "yandex_vpc_subnet" "subnet-b" {
  subnet_id = yandex_vpc_subnet.subnet-b.id
}
