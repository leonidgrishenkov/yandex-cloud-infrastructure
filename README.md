[![Destroy Resources](https://github.com/leonidgrishenkov/yandex-cloud-infrastructure/actions/workflows/destroy.yml/badge.svg)](https://github.com/leonidgrishenkov/yandex-cloud-infrastructure/actions/workflows/destroy.yml) [![Deploy Resources](https://github.com/leonidgrishenkov/yandex-cloud-infrastructure/actions/workflows/deploy.yml/badge.svg)](https://github.com/leonidgrishenkov/yandex-cloud-infrastructure/actions/workflows/deploy.yml)

# About

This repository manages infrastructure resources for Yandex Cloud using Infrastructure as Code (IaC) principles. The project utilizes Terraform with Yandex Object Storage (S3-compatible) as the backend for storing state files, ensuring reliable and consistent infrastructure management.

All infrastructure deployments and teardowns are orchestrated through manually triggered GitHub Actions workflows, providing controlled and auditable changes to the cloud environment.

The CI/CD pipeline leverages a Docker image specifically designed for Terragrunt and Yandex Cloud operations, available at [leonidgrishenkov/ci-terragrunt-yc](https://github.com/leonidgrishenkov/ci-terragrunt-yc).

# How to setup S3 backend

[Uploading Terraform states to Yandex Object Storage](https://yandex.cloud/en/docs/tutorials/infrastructure-management/terraform-state-storage#set-up-backend)
Create S3 bucket for terraform states and special service account for terraform with `editor` role:

```sh
cd ./live/global/s3/terraform-state

terraform apply
```

Create auth key for SA:

```sh
yc iam key create \
  --service-account-id $(yc iam service-account list --format json | jq -r '.[] | select(.name == "terraform-sa") | .id') \
  --folder-id $(yc config get folder-id) \
  --output /tmp/.terraform-sa-auth-key.json
```

Create `yc` profile for SA:

```sh
$ yc config profile create terraform-sa

Profile 'sa-terraform' created and activated
```

Configure profile:

```sh
yc config set service-account-key /tmp/.terraform-sa-auth-key.json
yc config set cloud-id $YC_CLOUD_ID
yc config set folder-id $YC_FOLDER_ID
```

Grab output of access and secret keys:

```sh
terraform output -json
```
