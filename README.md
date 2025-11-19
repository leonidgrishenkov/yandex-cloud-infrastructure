[![Destroy Resources](https://github.com/leonidgrishenkov/yandex-cloud-infrastructure/actions/workflows/destroy.yml/badge.svg)](https://github.com/leonidgrishenkov/yandex-cloud-infrastructure/actions/workflows/destroy.yml) [![Deploy Resources](https://github.com/leonidgrishenkov/yandex-cloud-infrastructure/actions/workflows/deploy.yml/badge.svg)](https://github.com/leonidgrishenkov/yandex-cloud-infrastructure/actions/workflows/deploy.yml)
[Yandex Cloud Terraform Provider](https://terraform-provider.yandexcloud.net/index)

# Configure Terraform

Here I will explain how to configure Terraform on your local machine to be able to work with Yandex Cloud Terraform provider.

For more details see official documentation: [Getting started with Terraform](https://yandex.cloud/en/docs/tutorials/infrastructure-management/terraform-quickstart)
Create configuration file for Terraform:

```sh
touch ~/.terraformrc
```

Add there the followings:

```sh
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

# Setup S3 backend

[Uploading Terraform states to Yandex Object Storage](https://yandex.cloud/en/docs/tutorials/infrastructure-management/terraform-state-storage#set-up-backend)
Create S3 bucket for terraform states and special service account for terraform with `editor` role:

```sh
$ cd ./live/global/s3/terraform-state

$ terraform apply
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
$ yc config set service-account-key /tmp/.terraform-sa-auth-key.json
$ yc config set cloud-id $YC_CLOUD_ID
$ yc config set folder-id $YC_FOLDER_ID
```

Grab output of access and secret keys:

```sh
terraform output -json
```

# Serial port output

Get serial port output of deployed compute instance:

```sh
yc compute instance get-serial-port-output --name prod-compute-1
```

# CI/CD

Docker image for GitHub CI/CD defined [here](https://github.com/leonidgrishenkov/ci-terragrunt-yc)
