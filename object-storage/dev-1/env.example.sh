#!/bin/bash

# Set required environment variables.
export YC_IAM_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_STORAGE_ADMIN_SA_ID=

# Set values of env variables as Terraform variables.
export TF_VAR_cloud_id=$YC_CLOUD_ID
export TF_VAR_folder_id=$YC_FOLDER_ID
export TF_VAR_iam_token=$YC_IAM_TOKEN
export TF_VAR_zone="ru-central1-a"
export TF_VAR_storage_admin_id=$YC_STORAGE_ADMIN_SA_ID
export TF_VAR_bucket_name=$YC_CLOUD_ID-dev-1
