
resource "random_password" "admin_password" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource "yandex_mdb_clickhouse_user" "admin" {
  cluster_id = yandex_mdb_clickhouse_cluster.cluster01.id
  name       = "yc-user"
  password   = random_password.admin_password.result
  permission {
    database_name = yandex_mdb_clickhouse_database.main.name
  }
}

