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
export YC_REGISTRY_ID=$(terraform output -json | jq -r '.["personal-registry-1-id"].value') \
    && export YC_REGISTRY_ADMIN_SA_ID=$(terraform output -json | jq -r '.["personal-container-registry-admin-id"].value')
```

# Create local config profile

Create SA key:

```sh
export YC_KEY_PATH=/tmp/personal-container-registry-admin.json \
    && yc iam key create \
        --service-account-id $YC_REGISTRY_ADMIN_SA_ID \
        --algorithm rsa-4096 \
        --output $YC_KEY_PATH
```

Create and activate config profile for this SA:

```sh
yc config profile create personal-container-registry-admin
```

Set folder id for the profile:

```sh
yc config set folder-id $YC_FOLDER_ID
```

# Authenticate docker

Create IAM token for the profile:

```sh
export YC_IAM_TOKEN=$(yc iam create-token)
```

Authenticate:

```sh
echo $YC_IAM_TOKEN | docker login --username iam --password-stdin cr.yandex
```

# Push an image

Tag an image:

```sh
docker tag ubuntu:latest cr.yandex/$YC_REGISTRY_ID/ubuntu:latest
```

Push an image:

```sh
docker push cr.yandex/$YC_REGISTRY_ID/ubuntu:latest
```
