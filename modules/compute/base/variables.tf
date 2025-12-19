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
  description = "VPC subnet ID"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "VPC security group IDs"
}

variable "vpc_nat_ip" {
  type        = string
  description = "VPC NAT IP address"
  default     = null
}

variable "name" {
  type        = string
  description = "Instance name"
}

variable "platform_id" {
  type        = string
  description = "Instance platform id"
}

variable "cores" {
  type        = string
  description = "Instance cores number"
}

variable "memory" {
  type        = string
  description = "Instance memory"
}

variable "disk_type" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "labels" {
  type = map(any)
}

variable "cloud_init_template_path" {
  type        = string
  description = "Path to cloud-init template file. If not specified default will be used."
  default     = null
}

variable "image_family" {
  type = string
}

variable "nat" {
  type = bool
  default = false
}
