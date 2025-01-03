data "yandex_compute_image" "container-optimized-image" {
  family = "container-optimized-image"
}

resource "random_password" "yc-user-passwd" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource "random_password" "github-ci-passwd" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource "yandex_compute_instance" "prod-compute-1" {
  name        = "prod-compute-1"
  hostname    = "prod-compute-1"
  platform_id = "standard-v3"
  zone        = var.zone
  folder_id   = var.folder_id
  labels = {
    env = "prod"
    type = "personal"
  }

  resources {
    cores         = 4
    memory        = 4
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      type     = "network-hdd"
      size     = 100
    }
    auto_delete = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.prod-vpc-1-subnet-a.id
    security_group_ids = [yandex_vpc_security_group.prod-vpc-1-sg-1.id]
    nat                = true
    ipv4               = true
    nat_ip_address     = yandex_vpc_address.prod-addr-1.external_ipv4_address[0].address
  }

  metadata = {
    user-data = templatefile("./cloud-init.yaml",
      {
        yc-user-passwd    = random_password.yc-user-passwd.bcrypt_hash,
        yc-user-ssh-key   = file("~/.ssh/prod-hosts.pub"),
        github-ci-passwd  = random_password.github-ci-passwd.bcrypt_hash,
        github-ci-ssh-key = file("~/.ssh/github-ci.pub"),
    })
  }
}
