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
$ cd ./global/s3/terraform-state

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

`YC_CLOUD_ID` and `YC_FOLDER_ID` variables have been already set via `.envrc` with main profile. If you didn't do this, just set them manually.

Grab output of access and secret keys:

```sh
terraform output -json
```

Go to folder with resources configurations. In this repo to `./prod/`

Add configuration for terraform itself, for example, into `terraform.tf` file:

```hcl
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    region  = "ru-central1"
    bucket  = "<bucket-name>"
    key     = "<prefix>/terraform.tfstate"
    encrypt = false

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}
```

Initialize terraform:

```sh
terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"
```

## Best practice

We need to configure terraform in each folder/module and we can't use variables here.

To avoid futher mistakes we can split static configurations into separate file called `backend.hcl` (you can use whatever you want) and leave only `key` here. So in each folder/module we have to only specify correct `key` value for the pacticular folder/module.

Now our `terraform.tf` file will look like that:

```hcl
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    key     = "<prefix>/terraform.tfstate"
  }
}
```

And `backend.hcl`:

```hcl
endpoints = {
    s3 = "https://storage.yandexcloud.net"
}
region  = "ru-central1"
bucket  = "<bucket-name>"
encrypt = false
skip_region_validation      = true
skip_credentials_validation = true
skip_requesting_account_id  = true
skip_s3_checksum            = true
```

To initialize terraform we will use following command:

```sh
terraform init \
    -backend-config="access_key=$ACCESS_KEY" \
    -backend-config="secret_key=$SECRET_KEY" \
    -backend-config=backend.hcl
```

# Use direnv

Enter to the directory with configurations and type:

```sh
direnv allow
```

Now all variables will be automatically loaded and unloaded into your shell on enter/exit directory.

# Terraform commands

## Output

Show terraform state:

```sh
terraform show
```

You can also run terraform console to query any state values:

```sh
terraform console
```

Show all project outputs:

```sh
terraform output
```

To see output in json format type:

```sh
terraform output -json
```

Also here you can see generated in runtime outputs such as passwords which are marked as sesitive.

## Destroy

Delete resources all resources:

```sh
terraform destroy
```

Destroy only specific resource:

```sh
terraform destroy -target yandex_compute_instance.dev-compute-1
```

# yc

Get serial port output of deployed compute instance:

```sh
yc compute instance get-serial-port-output --name prod-compute-1
```
