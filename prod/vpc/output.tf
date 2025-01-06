output "prod-addr-1" {
  value = yandex_vpc_address.prod-addr-1.external_ipv4_address[0].address
}

output "prod-vpc-1-subnet-a-id" {
  value = yandex_vpc_subnet.prod-vpc-1-subnet-a.id
}

output "prod-vpc-1-subnet-b-id" {
  value = yandex_vpc_subnet.prod-vpc-1-subnet-b.id
}

output "prod-vpc-1-sg-1-id" {
  value = yandex_vpc_security_group.prod-vpc-1-sg-1.id
}
