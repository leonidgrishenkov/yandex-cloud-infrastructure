# Create resources

Set up values for all required terraform variables:

```sh
source env.sh
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
terraform plan
```

Create resources:

```sh
terraform apply
```

List created resources:

```sh
terraform state list
```

# Get output ids

Show all terraform outputs:

```sh
terraform output
```

Get created registry and SA ids from Terraform output:

```sh
export YC_REGISTRY_ID=$(terraform output -json | jq -r '.["dev-registry-1-id"].value') \
    && export YC_REGISTRY_ADMIN_SA_ID=$(terraform output -json | jq -r '.["dev-registry-1-admin-sa-id"].value')
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

```sh
yc config set service-account-key $YC_KEY_PATH
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
