# Creating a static access key.
resource "yandex_iam_service_account_static_access_key" "sa-key" {
  service_account_id = var.storage_admin_id
  description        = "Static access key for object storage administator"
}

# Creating a bucket using the key.
# https://terraform-provider.yandexcloud.net/Resources/storage_bucket
# https://yandex.cloud/en-ru/docs/storage/operations/buckets/create#tf_1
resource "yandex_storage_bucket" "bucket" {
  access_key            = yandex_iam_service_account_static_access_key.sa-key.access_key
  secret_key            = yandex_iam_service_account_static_access_key.sa-key.secret_key
  bucket                = var.bucket_name
  max_size              = "21474836480" # Max bucket size threshold. Set to 20 GB.
  default_storage_class = "STANDARD_IA"
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
