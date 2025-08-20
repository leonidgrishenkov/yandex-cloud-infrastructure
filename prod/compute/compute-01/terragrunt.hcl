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
  vpc_network_id = dependency("vpc").outputs.vpc_network_id
  subnet_ids     = dependency("vpc").outputs.subnet_ids
}

