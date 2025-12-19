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
  name                   = "debian-12"
  platform_id            = "standard-v3"
  image_family           = "debian-12"
  cores                  = 8
  memory                 = 16
  disk_type              = "network-hdd"
  disk_size              = 100
  vpc_subnet_id          = dependency.vpc.outputs.dev-vpc-1-subnet-a-id
  vpc_security_group_ids = dependency.vpc.outputs.dev-vpc-1-sg-ids
  cloud_init_template_path = "./cloud-init.yaml"
  labels = {
    env = "dev"
    iac = "true"
  }
}

