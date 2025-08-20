variable "cloud_id" {
  type        = string
  description = "Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
}

variable "iam_token" {
  type        = string
  description = "IAM Token"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "vpc_subnet_id" {
  type        = string
  description = "VPC subnet ID from dependency"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "VPC security group IDs from dependency"
}

variable "vpc_nat_ip" {
  type        = string
  description = "VPC NAT IP address from dependency"
}
