# This is a KRaft kafka cluster.
# https://yandex.cloud/ru/docs/terraform/resources/mdb_kafka_cluster
resource "yandex_mdb_kafka_cluster" "cluster" {
  environment = "PRESTABLE"
  name        = "cluster01"

  network_id         = var.vpc_id
  subnet_ids         = var.vpc_subnet_ids
  security_group_ids = var.vpc_sg_ids
  folder_id          = var.folder_id

  deletion_protection = false

  labels = var.labels

  # Increase timeouts for cluster operations to prevent terraform from raising an error.
  timeouts {
    create = "2h"
    update = "2h"
    delete = "1h"
  }

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
        auto_create_topics_enable  = true
        compression_type           = "COMPRESSION_TYPE_ZSTD"
        num_partitions             = 3
        default_replication_factor = 3
      }
    }
  }
}
