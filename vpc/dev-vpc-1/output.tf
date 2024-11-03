output "dev-vpc-1-sg-1-id" {
  value = data.yandex_vpc_security_group.sg.id
}

output "dev-vpc-1-subnet-a-id" {
  value = data.yandex_vpc_subnet.subnet-a.id
}

output "dev-vpc-1-subnet-b-id" {
  value = data.yandex_vpc_subnet.subnet-b.id
}

