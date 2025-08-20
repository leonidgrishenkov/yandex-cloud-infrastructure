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
  vpc_subnet_id = dependency.vpc.outputs.prod-vpc-1-subnet-a-id
  vpc_security_group_ids = dependency.vpc.outputs.prod-vpc-1-sg-ids
  vpc_nat_ip = dependency.vpc.outputs.prod-addr-1
}

