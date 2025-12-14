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

variable "vpc_subnet_ids" {
  type = list(string)
}

variable "vpc_sg_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "labels" {
  type = map(any)
}



