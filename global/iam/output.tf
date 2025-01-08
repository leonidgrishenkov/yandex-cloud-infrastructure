output "s3-admin-access-key" {
  value = yandex_iam_service_account_static_access_key.admin-sa-sak.access_key
}
output "s3-admin-secret-key" {
  value     = yandex_iam_service_account_static_access_key.admin-sa-sak.secret_key
  sensitive = true
}

output "s3-uploader-access-key" {
  value = yandex_iam_service_account_static_access_key.uploader-sa-sak.access_key
}
output "s3-uploader-secret-key" {
  value     = yandex_iam_service_account_static_access_key.uploader-sa-sak.secret_key
  sensitive = true
}

output "s3-viewer-access-key" {
  value = yandex_iam_service_account_static_access_key.viewer-sa-sak.access_key
}
output "s3-viewer-secret-key" {
  value     = yandex_iam_service_account_static_access_key.viewer-sa-sak.secret_key
  sensitive = true
}
