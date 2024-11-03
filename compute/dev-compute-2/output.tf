output "dev-compute-2-external-ip" {
  value = data.yandex_compute_instance.compute.network_interface.0.nat_ip_address
}
output "dev-compute-2-internal-ip" {
  value = data.yandex_compute_instance.compute.network_interface.0.ip_address
}

output "dev-compute-2-password" {
  value     = random_password.compute-password.result
  sensitive = true
}
