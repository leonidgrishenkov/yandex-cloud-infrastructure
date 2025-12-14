output "admin_name" {
  value = yandex_mdb_clickhouse_user.admin.name
}

output "admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}
