# https://yandex.cloud/ru/docs/terraform/resources/mdb_clickhouse_cluster
resource "yandex_mdb_clickhouse_cluster" "cluster01" {
  name        = "ch-cluster01"
  description = "Clickhouse sharded cluster"

  version     = "25.10"
  environment = "PRESTABLE"

  folder_id          = var.folder_id
  network_id         = var.vpc_id
  security_group_ids = var.vpc_sg_ids

  # Increase timeouts for cluster operations to prevent terraform from raising an error.
  timeouts {
    create = "2h"
    update = "2h"
    delete = "1h"
  }

  deletion_protection = false
  labels = {
    env = "dev"
    iac = "true"
  }

  # Use ClickHouse Keeper as a coordination system instead of Zookeeper and place it on the same hosts with ClickHouse.
  embedded_keeper = true

  # Access policy
  access {
    data_lens     = false
    data_transfer = false
    metrika       = false
    serverless    = false
    web_sql       = false
    yandex_query  = false
  }

  clickhouse {
    # This resource definition will be shared between all hosts (if not defined for any of them).
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 50
    }

    config {
      kafka {
        security_protocol = "SASL_SSL"
        sasl_mechanism    = "SCRAM-SHA-512"
        sasl_username     = var.kafka_consumer_name
        sasl_password     = var.kafka_consumer_password
      }
    }
  }

  # Shards definition
  shard {
    name   = "shard1"
    weight = 100
  }
  shard {
    name   = "shard2"
    weight = 100
  }

  # Hosts definition
  # Zone A
  host {
    type             = "CLICKHOUSE"
    zone             = "ru-central1-a"
    assign_public_ip = true
    subnet_id        = var.vpc_subnet_a_id
    shard_name       = "shard1"
  }
  host {
    type       = "CLICKHOUSE"
    zone       = "ru-central1-a"
    subnet_id  = var.vpc_subnet_a_id
    shard_name = "shard2"
  }
  # Zone B
  host {
    type       = "CLICKHOUSE"
    zone       = "ru-central1-b"
    subnet_id  = var.vpc_subnet_b_id
    shard_name = "shard1"
  }
  host {
    type       = "CLICKHOUSE"
    zone       = "ru-central1-b"
    subnet_id  = var.vpc_subnet_b_id
    shard_name = "shard2"
  }
  # Zone D
  host {
    type       = "CLICKHOUSE"
    zone       = "ru-central1-d"
    subnet_id  = var.vpc_subnet_d_id
    shard_name = "shard1"
  }
  host {
    type       = "CLICKHOUSE"
    zone       = "ru-central1-d"
    subnet_id  = var.vpc_subnet_d_id
    shard_name = "shard2"
  }

  # Ignore conflict with resources created by other tools (means not by terraform).
  lifecycle {
    ignore_changes = [database, user]
  }
}

