output "s3-sak" {
  value = {
    for name, sak in yandex_iam_service_account_static_access_key.s3-sak : name => {
      access_key = sak.access_key
      secret_key = sak.secret_key
    }
  }
  sensitive = true
}
