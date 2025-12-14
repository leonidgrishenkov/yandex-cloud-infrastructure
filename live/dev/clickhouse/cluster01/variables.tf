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

variable "vpc_id" {
  type = string
}

variable "vpc_sg_ids" {
  type        = list(string)
  description = "VPC security group IDs"
}

variable "vpc_subnet_a_id" {
  type = string
}

variable "vpc_subnet_b_id" {
  type = string
}

variable "vpc_subnet_d_id" {
  type = string
}

variable "kafka_consumer_name" {
  type = string
}

variable "kafka_consumer_password" {
  type      = string
  sensitive = true
}

