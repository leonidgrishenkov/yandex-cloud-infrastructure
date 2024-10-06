output "dev-registry-1-id" {
    value = data.yandex_container_registry.registry.registry_id
}

output "dev-registry-1-admin-sa-id" {
  value = data.yandex_iam_service_account.sa.service_account_id
}
