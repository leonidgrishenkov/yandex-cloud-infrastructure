resource "random_password" "admin_password" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = false
}

resource "random_password" "ch_consumer_password" {
  length  = 20
  upper   = true
  lower   = true
  numeric = true
  special = false
}

# https://yandex.cloud/ru/docs/terraform/resources/mdb_kafka_user
resource "yandex_mdb_kafka_user" "admin" {
  cluster_id = yandex_mdb_kafka_cluster.cluster.id
  name       = "admin"
  password   = random_password.admin_password.result

  permission {
    topic_name = "*" # all topics, because we set 'auto_create_topics_enable' to 'true'
    role       = "ACCESS_ROLE_ADMIN"
  }
}

resource "yandex_mdb_kafka_user" "ch_consumer" {
  cluster_id = yandex_mdb_kafka_cluster.cluster.id
  name       = "ch_consumer"
  password   = random_password.ch_consumer_password.result

  permission {
    topic_name = "*"
    role       = "ACCESS_ROLE_CONSUMER"
  }
}
