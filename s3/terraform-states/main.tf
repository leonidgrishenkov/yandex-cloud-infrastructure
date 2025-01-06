resource "yandex_iam_service_account_static_access_key" "terraform-states-admin-static-key" {
  service_account_id = yandex_iam_service_account.terraform-states-admin.id
  description        = "Static access key for administator of s3 bucket: terraform-states"
}

# Symmetric key for bucket encryption.
# https://terraform-provider.yandexcloud.net/Resources/kms_symmetric_key
resource "yandex_kms_symmetric_key" "terraform-states-key-1" {
  name              = "terraform-states-key-1"
  description       = "Symmetric key for s3 bucket encryption: terraform-states"
  default_algorithm = "AES_128"
  folder_id         = var.folder_id
}

# https://terraform-provider.yandexcloud.net/Resources/storage_bucket
# https://yandex.cloud/en-ru/docs/storage/operations/buckets/create#tf_1
resource "yandex_storage_bucket" "terraform-states" {
  access_key            = yandex_iam_service_account_static_access_key.terraform-states-admin-static-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.terraform-states-admin-static-key.secret_key
  bucket                = "terraform-states-${var.cloud_id}"
  max_size              = "5368709120" # Max bucket size threshold. Set to 5GB.
  default_storage_class = "STANDARD"
  acl                   = "private"
  folder_id             = var.folder_id

  # Enable object versioning in bucket.
  # Required for objects locking.
  versioning {
    enabled = true
  }
  anonymous_access_flags {
    read        = false
    list        = false
    config_read = false
  }

  # Configure server side encryption for bucket.
  # https://terraform-provider.yandexcloud.net/Resources/storage_bucket.html#using-sse
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.terraform-states-key-1.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # Enable objects locking.
  # About:
  #   1. https://yandex.cloud/en-ru/docs/storage/concepts/object-lock
  #   2. https://yandex.cloud/en-ru/docs/storage/operations/buckets/configure-object-lock
  object_lock_configuration {
    object_lock_enabled = "Enabled"
    rule {
      default_retention {
        mode  = "GOVERNANCE"
        years = 1
      }
    }
  }
}
