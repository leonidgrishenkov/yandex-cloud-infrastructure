output "passwd" {
  value     = random_password.passwd.result
  sensitive = true
  description = "User's password"
}

output "ssh_private_key" {
  value       = tls_private_key.ssh_key.private_key_openssh
  sensitive   = true
  description = "User's SSH private key"
}

output "ssh_public_key" {
  value       = tls_private_key.ssh_key.public_key_openssh
  description = "User's SSH public key"
}

output "vpc_nat_ip" {
  value       = yandex_compute_instance.yci.network_interface[0].nat_ip_address
  description = "VPC NAT public IP address"
}
