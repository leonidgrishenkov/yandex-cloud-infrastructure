output "admin_name" {
  value = yandex_mdb_kafka_user.admin.name
}

output "admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}

output "ch_consumer_name" {
  value = yandex_mdb_kafka_user.ch_consumer.name
}

output "ch_consumer_password" {
  value     = random_password.ch_consumer_password.result
  sensitive = true
}
