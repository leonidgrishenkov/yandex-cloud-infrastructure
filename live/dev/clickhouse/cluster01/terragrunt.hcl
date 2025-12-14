include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "."
}

dependency "vpc" {
  config_path = "../../vpc"
}

dependency "kafka" {
  config_path = "../../kafka/cluster01"

  mock_outputs = {
    ch_consumer_name     = "mock_name"
    ch_consumer_password = "mock_password"
  }
}

inputs = {
  vpc_id = dependency.vpc.outputs.dev-vpc-1-id

  vpc_subnet_a_id = dependency.vpc.outputs.dev-vpc-1-subnet-a-id
  vpc_subnet_b_id = dependency.vpc.outputs.dev-vpc-1-subnet-b-id
  vpc_subnet_d_id = dependency.vpc.outputs.dev-vpc-1-subnet-d-id

  vpc_sg_ids = dependency.vpc.outputs.dev-vpc-1-sg-ids

  kafka_consumer_name     = dependency.kafka.outputs.ch_consumer_name
  kafka_consumer_password = dependency.kafka.outputs.ch_consumer_password

}

