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

variable "s3_access_key" {
  type = string
}

variable "s3_secret_key" {
  type = string
}


