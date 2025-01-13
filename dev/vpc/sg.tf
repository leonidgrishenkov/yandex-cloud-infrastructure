resource "yandex_vpc_security_group" "dev-vpc-1-sg-1" {
  name       = "dev-vpc-1-sg-1"
  network_id = yandex_vpc_network.dev-vpc-1.id

  ingress {
    protocol          = "ANY"
    description       = "Self security group traffic"
    from_port         = 0
    to_port           = 65535
    predefined_target = "self_security_group"
  }
  egress {
    protocol          = "ANY"
    description       = "Self security group traffic"
    from_port         = 0
    to_port           = 65535
    predefined_target = "self_security_group"
  }
}

resource "yandex_vpc_security_group" "dev-vpc-1-sg-2" {
  name       = "dev-vpc-1-sg-2"
  network_id = yandex_vpc_network.dev-vpc-1.id

  ingress {
    protocol       = "ANY"
    description    = "All traffic from my IP"
    v4_cidr_blocks = ["185.61.78.47/32"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "TCP"
    description    = "All traffic to SSH port"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 51222
  }
}


resource "yandex_vpc_security_group" "dev-vpc-1-sg-3" {
  name       = "dev-vpc-1-sg-3"
  network_id = yandex_vpc_network.dev-vpc-1.id

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
