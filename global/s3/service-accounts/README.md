# Create resources

Set up values for variables:

```sh
export YC_IAM_TOKEN=$(yc iam create-token) \
    && export YC_CLOUD_ID=$(yc config get cloud-id) \
    && export YC_FOLDER_ID=$(yc config get folder-id)
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
    -var="yc-folder-id=$YC_FOLDER_ID"
```

Create resources:

```sh
terraform apply \
    -var="yc-iam-token=$YC_IAM_TOKEN" \
    -var="yc-cloud-id=$YC_CLOUD_ID" \
    -var="yc-folder-id=$YC_FOLDER_ID"
```

List created resources:

```sh
terraform state list
```

# Get output ids

Get created registry and SA ids from Terraform output:

```sh
export YC_STORAGE_ADMIN_SA_ID=$(terraform output -json | jq -r '.["storage-admin-id"].value')
```

# Accessing storage

Create access key for this SA:

```sh
yc iam access-key create --service-account-id $YC_STORAGE_ADMIN_SA_ID
```

I manually set it into `.env` file.

