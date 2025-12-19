output "yc_user_passwd" {
  value     = random_password.yc_user_passwd.result
  sensitive = true
  description = "yc-user's password"
}

output "ssh_private_key" {
  value       = tls_private_key.yc_user_ssh_key.private_key_openssh
  sensitive   = true
  description = "yc-user's SSH private key"
}

output "ssh_public_key" {
  value       = tls_private_key.yc_user_ssh_key.public_key_openssh
  description = "yc-user's SSH public key"
}
