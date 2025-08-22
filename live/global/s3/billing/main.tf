resource "yandex_storage_bucket" "bucket" {
  access_key            = var.access_key
  secret_key            = var.secret_key
  bucket                = "billing-${var.cloud_id}-1"
  max_size              = "5368709120" # Max bucket size threshold. Set to 5GB.
  default_storage_class = "STANDARD"
  acl                   = "private"
  folder_id             = var.folder_id

  versioning {
    enabled = false
  }
  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }

  # Enable bucket logging.
  # https://yandex.cloud/en-ru/docs/storage/operations/buckets/enable-logging
  logging {
    target_bucket = "logging-b1gcj63q69dgi7jup4i5-1"
    target_prefix = "billing/"
  }

  # Define lifecycle rules.
  # https://yandex.cloud/en-ru/docs/storage/operations/buckets/lifecycles
  # STANDARD -> COLD after 30 days.
  lifecycle_rule {
    id      = "to_cold_after_30d"
    enabled = true
    transition {
      days          = 30
      storage_class = "COLD"
    }
  }
  # COLD -> ICE after 90 days.
  lifecycle_rule {
    id      = "to_ice_after_90d"
    enabled = true
    transition {
      days          = 90
      storage_class = "ICE"
    }
  }
}
