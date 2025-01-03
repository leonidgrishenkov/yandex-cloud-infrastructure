# Configure Terraform

Here I will explain how to configure Terraform on your local machine to be able to work with Yandex Cloud Terraform provider.

For more details see official documentation: [Getting started with Terraform | Yandex Cloud](https://yandex.cloud/en/docs/tutorials/infrastructure-management/terraform-quickstart)

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
