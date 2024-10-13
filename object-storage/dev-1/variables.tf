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

variable "storage_admin_id" {
  type        = string
  description = "Storage administator service account ID"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name"
}
