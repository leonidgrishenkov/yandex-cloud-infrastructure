data "yandex_compute_image" "image" {
  family = "container-optimized-image"
}

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

resource "yandex_compute_instance" "yci" {
  name        = var.name
  hostname    = var.name
  platform_id = var.platform_id
  zone        = var.zone
  folder_id   = var.folder_id

  labels = var.labels

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type     = var.disk_type
      size     = var.disk_size
    }
    auto_delete = true
  }

  network_interface {
    subnet_id          = var.vpc_subnet_id
    security_group_ids = var.vpc_security_group_ids
    nat                = true
    ipv4               = true
    nat_ip_address     = var.vpc_nat_ip
  }
  metadata = {
    user-data = templatefile(
      coalesce(var.cloud_init_template_path, "${path.module}/cloud-init.yaml"),
      {
        yc_user_passwd  = random_password.yc_user_passwd.bcrypt_hash,
        yc_user_ssh_key = tls_private_key.yc_user_ssh_key.public_key_openssh
      }
    )
  }
}
