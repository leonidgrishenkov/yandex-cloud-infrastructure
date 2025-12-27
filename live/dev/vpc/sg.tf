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
    description    = "IP whitelist for all traffic"
    v4_cidr_blocks = ["185.61.76.113/32", "80.251.236.252/32"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "dev-vpc-1-sg-3" {
  name       = "dev-vpc-1-sg-3"
  network_id = yandex_vpc_network.dev-vpc-1.id

  egress {
    description    = "Allow outgoing connections to any required resource"
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
