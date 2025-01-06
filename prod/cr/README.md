Initialize terraform:

```sh
terraform init \
    -backend-config="access_key=$ACCESS_KEY" \
    -backend-config="secret_key=$SECRET_KEY" \
    -backend-config=../backend.hcl
```
