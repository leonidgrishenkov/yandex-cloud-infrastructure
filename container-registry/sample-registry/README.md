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

# Work with output

Show output:

```sh
terraform output
```

In json format:

```sh
terraform output -json
```

Subset registry id from output with `jq`:

```sh
export YC_REGISTRY_ID=$(terraform output -json | jq -r '.["registry-1-id"].value')
```

# Push an image

Example image: `python:3.12.5-slim`

Activate registry admin profile (should be created before):

```sh
yc config profile activate container-registry-admin
```

Set IAM token of this profile:

```sh
export YC_IAM_TOKEN=$(yc iam create-token)
```

Login docker:

```sh
echo $YC_IAM_TOKEN | docker login --username iam --password-stdin cr.yandex
```

Tag an image:

```sh
docker tag python:3.12.5-slim cr.yandex/$YC_REGISTRY_ID/python:3.12.5-slim
```

Now push:

```sh
docker push cr.yandex/$YC_REGISTRY_ID/postgres-ssl:16.4-bullseye-1.6
```

If everything is ok, image will be pushed into this registry.

# Delete resources

To delete created resources execute:

```sh
terraform destroy \
    -var="yc-iam-token=$YC_IAM_TOKEN" \
    -var="yc-cloud-id=$YC_CLOUD_ID" \
    -var="yc-folder-id=$YC_FOLDER_ID"
```

Before this step, don't forget to:

-   Delete all images inside the registry
-   Activate cloud owner profile (or any kind of profile that has permissions to manipulate the cloud or the registry) and set his IAM token as `YC_IAM_TOKEN` environment variable. In this example we also use `container-registry-admin` profile because it has admin priviliges on registry. In other case you will get an error.
