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
  vpc_id = dependency.vpc.outputs.dev-vpc-1-id

  vpc_subnet_a_id = dependency.vpc.outputs.dev-vpc-1-subnet-a-id
  vpc_subnet_b_id = dependency.vpc.outputs.dev-vpc-1-subnet-b-id
  vpc_subnet_d_id = dependency.vpc.outputs.dev-vpc-1-subnet-d-id
 
  vpc_sg_ids = dependency.vpc.outputs.dev-vpc-1-sg-ids
}

