include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/compute//base"
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  name                   = "container-opimized"
  platform_id            = "standard-v3"
  image_family           = "container-optimized-image"
  cores                  = 8
  memory                 = 16
  disk_type              = "network-hdd"
  disk_size              = 100
  vpc_subnet_id          = dependency.vpc.outputs.dev-vpc-1-subnet-a-id
  vpc_security_group_ids = dependency.vpc.outputs.dev-vpc-1-sg-ids
  vpc_nat_ip               = dependency.vpc.outputs.dev-addr-1
  cloud_init_template_path = "./cloud-init.yaml"
  labels = {
    env = "dev"
    iac = "true"
  }
}

