include "root" {
    path = find_in_parent_folders("root.hcl")
}

terraform {
    source = "."
}

dependency "iam" {
  config_path = "../../iam"
}

inputs = {
  access_key = dependency.iam.outputs.s3-sak["s3-admin"].access_key
  secret_key = dependency.iam.outputs.s3-sak["s3-admin"].secret_key
}

