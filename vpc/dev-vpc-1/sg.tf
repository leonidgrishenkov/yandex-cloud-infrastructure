resource "yandex_vpc_security_group" "sg" {
  name        = "dev-vpc-1-sg-1"
  network_id  = yandex_vpc_network.vpc.id

  # Ingress traffic
  ingress {
    protocol       = "ANY"
    description    = "All traffic from my local IP"
    v4_cidr_blocks = ["185.61.78.47/32"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "All self traffic"
    predefined_target = "self_security_group"
  }

  # Egress traffic
  egress {
    protocol       = "TCP"
    description    = "All HTTP traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }
  egress {
    protocol       = "TCP"
    description    = "All HTTPS traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
  egress {
    protocol          = "ANY"
    description       = "All self traffic"
    predefined_target = "self_security_group"
  }
}

data "yandex_vpc_security_group" "sg" {
  security_group_id = yandex_vpc_security_group.sg.id
}

