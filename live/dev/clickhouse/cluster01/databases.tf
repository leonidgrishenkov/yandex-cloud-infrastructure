
resource "yandex_mdb_clickhouse_database" "main" {
  cluster_id = yandex_mdb_clickhouse_cluster.cluster01.id
  name       = "main"
}
