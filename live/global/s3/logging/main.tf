# https://terraform-provider.yandexcloud.net/Resources/storage_bucket
# https://yandex.cloud/en-ru/docs/storage/operations/buckets/create#tf_1
resource "yandex_storage_bucket" "bucket" {
  access_key            = var.access_key
  secret_key            = var.secret_key
  bucket                = "logging-${var.cloud_id}-1"
  max_size              = "21474836480" # Max bucket size threshold. Set to 20GB.
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
}
