resource "yandex_vpc_security_group" "k8s-main-sg" {
  name        = "k8s-main-sg"
  description = "Group rules ensure the basic performance of the cluster. Apply it to the cluster and node groups."
  network_id  = var.network_id
  # Ingress traffic
  ingress {
    protocol          = "TCP"
    description       = "The rule allows availability checks from the load balancer's range of addresses. It is required for the operation of a fault-tolerant cluster and load balancer services."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "The rule allows the master-node and node-node interaction within the security group."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "The rule allows the pod-pod and service-service interaction. Specify the subnets of your cluster and services."
    v4_cidr_blocks = ["10.0.0.0/24"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol       = "ICMP"
    description    = "The rule allows receipt of debugging ICMP packets from internal subnets."
    v4_cidr_blocks = ["10.0.0.0/24"]
  }

  # Egress traffic
  egress {
    protocol       = "ANY"
    description    = "The rule allows all outgoing traffic. Nodes can connect to Yandex Container Registry, Object Storage, Docker Hub, and more."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "k8s-public-services" {
  name        = "k8s-public-services"
  description = "Group rules allow connections to services from the internet. Apply the rules only for node groups."
  network_id  = var.network_id

  ingress {
    protocol       = "TCP"
    description    = "Rule allows incoming traffic from the internet to the NodePort port range. Add ports or change existing ones to the required ports."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

resource "yandex_vpc_security_group" "k8s-nodes-ssh-access" {
  name        = "k8s-nodes-ssh-access"
  description = "Правила группы разрешают подключение к узлам кластера по SSH. Примените правила только для групп узлов."
  network_id  = var.network_id

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к узлам по SSH с указанных IP-адресов."
    v4_cidr_blocks = ["0.0.0.0/0"] # ["185.61.78.47/32"]
    port           = 22
  }
}

resource "yandex_vpc_security_group" "k8s-master-whitelist" {
  name        = "k8s-master-whitelist"
  description = "Правила группы разрешают доступ к API Kubernetes из интернета. Примените правила только к кластеру."
  network_id  = var.network_id

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к API Kubernetes через порт 6443 из указанной сети."
    v4_cidr_blocks = ["0.0.0.0/0"] # ["185.61.78.47/32"]
    port           = 6443
  }

  ingress {
    protocol       = "TCP"
    description    = "Правило разрешает подключение к API Kubernetes через порт 443 из указанной сети."
    v4_cidr_blocks = ["0.0.0.0/0"] # ["185.61.78.47/32"]
    port           = 443
  }
}
