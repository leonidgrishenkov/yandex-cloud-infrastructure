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
    -var="yc-folder-id=$YC_FOLDER_ID" \
    -var="yc-storage-admin-id=$YC_STORAGE_ADMIN_SA_ID"
```

Create resources:

```sh
terraform apply \
    -var="yc-iam-token=$YC_IAM_TOKEN" \
    -var="yc-cloud-id=$YC_CLOUD_ID" \
    -var="yc-folder-id=$YC_FOLDER_ID" \
    -var="yc-storage-admin-id=$YC_STORAGE_ADMIN_SA_ID"
```

You can list created resources by executing:

```sh
terraform state list
```

Delete resources:

```sh
terraform destroy \
    -var="yc-iam-token=$YC_IAM_TOKEN" \
    -var="yc-cloud-id=$YC_CLOUD_ID" \
    -var="yc-folder-id=$YC_FOLDER_ID" \
    -var="yc-storage-admin-id=$YC_STORAGE_ADMIN_SA_ID"
```
