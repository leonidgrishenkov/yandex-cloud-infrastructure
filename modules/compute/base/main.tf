data "yandex_compute_image" "image" {
  count = var.image_family != null ? 1 : 0

  family = var.image_family
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

  # Either initialize_params or disk_id must be set. Either image_id or snapshot_id must be specified.
  boot_disk {
    disk_id = var.disk_id
    mode    = var.disk_mode

    initialize_params {
      image_id    = try(data.yandex_compute_image.image[0].id, null)
      type        = var.disk_type
      size        = var.disk_size
      snapshot_id = var.snapshot_id
    }
    auto_delete = var.disk_auto_delete
  }

  network_interface {
    subnet_id          = var.vpc_subnet_id
    security_group_ids = var.vpc_security_group_ids
    nat                = var.nat
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
