# This is a KRaft kafka cluster.
# https://yandex.cloud/ru/docs/terraform/resources/mdb_kafka_cluster
resource "yandex_mdb_kafka_cluster" "cluster" {
  environment = "PRESTABLE"
  name        = "cluster01"

  network_id         = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = var.vpc_sg_ids
  folder_id          = var.folder_id

  deletion_protection = false

  config {
    version          = "3.9"
    zones            = ["ru-central1-a"]
    brokers_count    = 3
    assign_public_ip = true
    schema_registry  = false
    rest_api {
      enabled = true
    }

    # https://yandex.cloud/en/docs/managed-kafka/concepts/kafka-ui
    kafka_ui {
      enabled = true
    }

    kafka {
      resources {
        disk_size          = 32
        disk_type_id       = "network-ssd"
        resource_preset_id = "s2.micro"
      }

      kafka_config {
        compression_type           = "COMPRESSION_TYPE_ZSTD"
        num_partitions             = 3
        default_replication_factor = 3
      }
    }
  }

}

# https://yandex.cloud/ru/docs/terraform/resources/mdb_kafka_topic
resource "yandex_mdb_kafka_topic" "topic01" {
  cluster_id         = yandex_mdb_kafka_cluster.cluster.id
  name               = "events"
  partitions         = 3
  replication_factor = 3

  topic_config {
    cleanup_policy        = "CLEANUP_POLICY_COMPACT"
    compression_type      = "COMPRESSION_TYPE_LZ4"
    delete_retention_ms   = 86400000
    file_delete_delay_ms  = 60000
    flush_messages        = 128
    flush_ms              = 1000
    min_compaction_lag_ms = 0
    retention_bytes       = 10737418240
    retention_ms          = 604800000
    max_message_bytes     = 1048588
    min_insync_replicas   = 1
    segment_bytes         = 268435456
  }
}
