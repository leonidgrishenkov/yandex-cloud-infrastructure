include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../../modules/compute//base"
}

dependency "vpc" {
  config_path = "../../../../vpc"
}

inputs = {
  name                     = "microk8s-controlplane"
  platform_id              = "standard-v3"
  image_family             = "ubuntu-2204-lts-oslogin"
  cores                    = 8
  memory                   = 16
  disk_type                = "network-ssd"
  disk_size                = 50
  vpc_subnet_id            = dependency.vpc.outputs.dev-vpc-1-subnet-a-id
  vpc_security_group_ids   = dependency.vpc.outputs.dev-vpc-1-sg-ids
  zone                     = "ru-central1-a"
  cloud_init_template_path = find_in_parent_folders("cloud-init.yaml")
  labels = {
    env = "dev"
    iac = "true"
  }
}

