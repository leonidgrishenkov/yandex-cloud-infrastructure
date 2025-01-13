output "dev-vpc-1-subnet-a-id" {
  value = yandex_vpc_subnet.dev-vpc-1-subnet-a.id
}

output "dev-vpc-1-subnet-b-id" {
  value = yandex_vpc_subnet.dev-vpc-1-subnet-b.id
}

output "dev-vpc-1-sg-1-id" {
  value = yandex_vpc_security_group.dev-vpc-1-sg-1.id
}
output "dev-vpc-1-sg-2-id" {
  value = yandex_vpc_security_group.dev-vpc-1-sg-2.id
}
output "dev-vpc-1-sg-3-id" {
  value = yandex_vpc_security_group.dev-vpc-1-sg-3.id
}

output "dev-vpc-1-sg-ids" {
  value = [
    yandex_vpc_security_group.dev-vpc-1-sg-1.id,
    yandex_vpc_security_group.dev-vpc-1-sg-2.id,
    yandex_vpc_security_group.dev-vpc-1-sg-3.id,
  ]
}
