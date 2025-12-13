include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "."
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  name                     = "compute-data-platform"
  platform_id              = "standard-v3"
  cores                    = 2
  memory                   = 6
  disk_type                = "network-ssd"
  disk_size                = 70
  vpc_subnet_id            = dependency.vpc.outputs.dev-vpc-1-subnet-a-id
  vpc_security_group_ids   = dependency.vpc.outputs.dev-vpc-1-sg-ids
  vpc_nat_ip               = dependency.vpc.outputs.dev-addr-1
  labels = {
    env = "dev"
    iac = "true"
  }
}

