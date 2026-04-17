
resource "random_password" "passwd" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}


resource "local_file" "ssh_key_file" {
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = pathexpand("${local.ssh_keys_dir}/${var.name}/${var.username}")
  file_permission = "0600"
}

resource "local_file" "ssh_key_pub_file" {
  content         = tls_private_key.ssh_key.public_key_openssh
  filename        = pathexpand("${local.ssh_keys_dir}/${var.name}/${var.username}.pub")
  file_permission = "0644"
}
