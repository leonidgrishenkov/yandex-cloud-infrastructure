output "admin-sa-access-key" {
  value = yandex_iam_service_account_static_access_key.admin-sa-sak.access_key
}
output "admin-sa-secret-key" {
  value     = yandex_iam_service_account_static_access_key.admin-sa-sak.secret_key
  sensitive = true
}

output "uploader-sa-access-key" {
  value = yandex_iam_service_account_static_access_key.uploader-sa-sak.access_key
}
output "uploader-sa-secret-key" {
  value     = yandex_iam_service_account_static_access_key.uploader-sa-sak.secret_key
  sensitive = true
}

output "viewer-sa-access-key" {
  value = yandex_iam_service_account_static_access_key.viewer-sa-sak.access_key
}
output "viewer-sa-secret-key" {
  value     = yandex_iam_service_account_static_access_key.viewer-sa-sak.secret_key
  sensitive = true
}
