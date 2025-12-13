# https://yandex.cloud/ru/docs/terraform/resources/mdb_clickhouse_cluster
resource "yandex_mdb_clickhouse_cluster" "ch-cluster01" {
  name        = "ch-cluster01"
  description = "Clickhouse sharded cluster"

  version     = "25.10"
  environment = "PRESTABLE"

  folder_id = var.folder_id
  network_id  = var.vpc_id
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
      # log_level                       = "TRACE"
      # max_connections                 = 100
      # max_concurrent_queries          = 50
      # keep_alive_timeout              = 3000
      # uncompressed_cache_size         = 8589934592
      # mark_cache_size                 = 5368709120
      # max_table_size_to_drop          = 53687091200
      # max_partition_size_to_drop      = 53687091200
      # timezone                        = "UTC"
      # geobase_uri                     = ""
      # query_log_retention_size        = 1073741824
      # query_log_retention_time        = 2592000
      # query_thread_log_enabled        = true
      # query_thread_log_retention_size = 536870912
      # query_thread_log_retention_time = 2592000
      # part_log_retention_size         = 536870912
      # part_log_retention_time         = 2592000
      # metric_log_enabled              = true
      # metric_log_retention_size       = 536870912
      # metric_log_retention_time       = 2592000
      # trace_log_enabled               = true
      # trace_log_retention_size        = 536870912
      # trace_log_retention_time        = 2592000
      # text_log_enabled                = true
      # text_log_retention_size         = 536870912
      # text_log_retention_time         = 2592000
      # text_log_level                  = "TRACE"
      # background_pool_size            = 16
      # background_schedule_pool_size   = 16
      #
      # merge_tree {
      #   replicated_deduplication_window                           = 100
      #   replicated_deduplication_window_seconds                   = 604800
      #   parts_to_delay_insert                                     = 150
      #   parts_to_throw_insert                                     = 300
      #   max_replicated_merges_in_queue                            = 16
      #   number_of_free_entries_in_pool_to_lower_max_size_of_merge = 8
      #   max_bytes_to_merge_at_min_space_in_pool                   = 1048576
      #   max_bytes_to_merge_at_max_space_in_pool                   = 161061273600
      # }
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

resource "yandex_mdb_clickhouse_database" "main" {
  cluster_id = yandex_mdb_clickhouse_cluster.ch-cluster01.id
  name       = "main"
}

resource "random_password" "admin-passwd" {
  length  = 20
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource "yandex_mdb_clickhouse_user" "admin" {
  cluster_id = yandex_mdb_clickhouse_cluster.ch-cluster01.id
  name       = "yc-user"
  password   = random_password.admin-passwd.result
  permission {
    database_name = yandex_mdb_clickhouse_database.main.name
  }
}

