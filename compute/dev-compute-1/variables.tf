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

variable "image_id" {
  type        = string
  description = "Virtual machine image ID"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}
