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
  name                     = "ubuntu-2204"
  platform_id              = "standard-v3"
  image_family             = "ubuntu-2204-lts-oslogin"
  cores                    = 16
  memory                   = 32
  disk_type                = "network-ssd"
  disk_size                = 50
  vpc_subnet_id            = dependency.vpc.outputs.dev-vpc-1-subnet-a-id
  vpc_security_group_ids   = dependency.vpc.outputs.dev-vpc-1-sg-ids
  cloud_init_template_path = "./cloud-init.yaml"
  labels = {
    env = "dev"
    iac = "true"
  }
}

