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

variable "network_id" {
  type        = string
  description = "Target network id"
}

variable "subnet_id" {
  type        = string
  description = "Target subnet id"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}
