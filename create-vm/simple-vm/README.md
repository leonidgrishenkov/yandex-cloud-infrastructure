Set up values for variables:

```sh
export YC_IAM_TOKEN=$(yc iam create-token) \
    && export YC_CLOUD_ID=$(yc config get cloud-id) \
    && export YC_FOLDER_ID=$(yc config get folder-id) \
    && export YC_IMAGE_ID=$(yc compute image get-latest-from-family ubuntu-2204-lts \
        --folder-id standard-images \
        --format json | jq -r ".id")
```

Initialize terraform:

```sh
terraform init
```

Optionaly you can validate specifications by executing:

```sh
terraform validate
```

Check specifications using those variables:

```sh
terraform plan \
    -var="yc-iam-token=$YC_IAM_TOKEN" \
    -var="yc-cloud-id=$YC_CLOUD_ID" \
    -var="yc-folder-id=$YC_FOLDER_ID" \
    -var="yc-image-id=$YC_IMAGE_ID"
```

Create resources:

```sh
terraform apply \
    -var="yc-iam-token=$YC_IAM_TOKEN" \
    -var="yc-cloud-id=$YC_CLOUD_ID" \
    -var="yc-folder-id=$YC_FOLDER_ID" \
    -var="yc-image-id=$YC_IMAGE_ID"
```

Delete resources:

```sh
terraform destroy \
    -var="yc-iam-token=$YC_IAM_TOKEN" \
    -var="yc-cloud-id=$YC_CLOUD_ID" \
    -var="yc-folder-id=$YC_FOLDER_ID" \
    -var="yc-image-id=$YC_IMAGE_ID"
```
