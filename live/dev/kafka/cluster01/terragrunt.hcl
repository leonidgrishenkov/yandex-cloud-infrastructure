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
  vpc_id         = dependency.vpc.outputs.dev-vpc-1-id
  vpc_subnet_ids = [dependency.vpc.outputs.dev-vpc-1-subnet-a-id]
  vpc_sg_ids     = dependency.vpc.outputs.dev-vpc-1-sg-ids
  labels = {
    env = "dev"
    iac = "true"
  }
}

