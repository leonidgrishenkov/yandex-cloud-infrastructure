resource "yandex_vpc_security_group" "sg" {
  name        = "dev-compute-1-sg-1"
  network_id  = yandex_vpc_network.network.id

  # Ingress traffic
  ingress {
    protocol       = "ANY"
    description    = "All ingress traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
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
    protocol       = "ANY"
    description    = "All egress traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
  egress {
    protocol          = "ANY"
    description       = "All self traffic"
    predefined_target = "self_security_group"
  }
}
