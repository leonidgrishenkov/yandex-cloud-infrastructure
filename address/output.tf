# https://terraform-provider.yandexcloud.net/DataSources/datasource_vpc_address
output "address" {
  value = yandex_vpc_address.addr.external_ipv4_address[0].address
}

