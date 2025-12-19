resource "random_password" "yc_user_passwd" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource "tls_private_key" "yc_user_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
