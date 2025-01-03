output "dev-compute-1-nat-ip-addr" {
  value = data.yandex_compute_instance.dev-compute-1.network_interface.0.nat_ip_address
}
output "dev-compute-1-ip-addr" {
  value = data.yandex_compute_instance.dev-compute-1.network_interface.0.ip_address
}

output "yc-user-passwd" {
  value     = random_password.yc-user-passwd.result
  sensitive = true
}

output "github-ci-passwd" {
  value     = random_password.github-ci-passwd.result
  sensitive = true
}
