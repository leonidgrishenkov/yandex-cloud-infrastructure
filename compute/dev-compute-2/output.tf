output "external-ip" {
  value = data.yandex_compute_instance.compute.network_interface.0.nat_ip_address
}
output "internal-ip" {
  value = data.yandex_compute_instance.compute.network_interface.0.ip_address
}

output "password" {
  value     = random_password.compute-password.result
  sensitive = true
}
