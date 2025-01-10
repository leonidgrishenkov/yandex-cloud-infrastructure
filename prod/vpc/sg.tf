resource "yandex_vpc_security_group" "prod-vpc-1-sg-1" {
  name       = "prod-vpc-1-sg-1"
  network_id = yandex_vpc_network.prod-vpc-1.id

  ingress {
    protocol          = "ANY"
    description       = "Self security group traffic"
    predefined_target = "self_security_group"
  }
  egress {
    protocol          = "ANY"
    description       = "Self security group traffic"
    predefined_target = "self_security_group"
  }
}

resource "yandex_vpc_security_group" "prod-vpc-1-sg-2" {
  name       = "prod-vpc-1-sg-2"
  network_id = yandex_vpc_network.prod-vpc-1.id

  ingress {
    protocol       = "ANY"
    description    = "Traffic from my local IP"
    v4_cidr_blocks = ["185.61.78.47/32"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "TCP"
    description    = "Traffic to SSH port"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}


resource "yandex_vpc_security_group" "prod-vpc-1-sg-3" {
  name       = "prod-vpc-1-sg-3"
  network_id = yandex_vpc_network.prod-vpc-1.id

  egress {
    protocol       = "ANY"
    description    = "All HTTP traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  egress {
    protocol       = "ANY"
    description    = "All HTTPS traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}
