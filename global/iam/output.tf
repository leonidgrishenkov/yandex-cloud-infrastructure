output "s3-sak" {
  value = {
    for name, sak in yandex_iam_service_account_static_access_key.s3-sak : name => {
      access_key = sak.access_key
      secret_key = sak.secret_key
    }
  }
  sensitive = true
}

output "cr-sa-auth-key" {
  value = {
    for name, ak in yandex_iam_service_account_key.cr-sa-auth-key : name => {
      id                 = ak.id
      service_account_id = ak.service_account_id
      created_at         = ak.created_at
      key_algorithm      = ak.key_algorithm
      public_key         = ak.public_key
      private_key        = ak.private_key
    }
  }
  sensitive = true
}
