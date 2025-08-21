include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/compute//container-optimized"
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
  name        = "prod-compute-1"
  platform_id = "standard-v3"
  cores         = 4
  memory        = 4
  disk_type     = "network-hdd"
  disk_size     = 100
  vpc_subnet_id = dependency.vpc.outputs.prod-vpc-1-subnet-a-id
  vpc_security_group_ids = dependency.vpc.outputs.prod-vpc-1-sg-ids
  vpc_nat_ip = dependency.vpc.outputs.prod-addr-1
}

