Set required environment variables:

```sh
source env.sh
```

Initialize terraform:

```sh
terraform init
```

Validate configurations:

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

Delete resources:

```sh
terraform destroy
```

# Output variables

```sh
export YC_K8S_CLUSTER_ID=$(terraform output -json | jq -r '.["k8s-cluster-id"].value')
```

# Work with k8s cluster

```sh
yc managed-kubernetes cluster list
```

Get kube config into specified file:

```sh
yc managed-kubernetes cluster get-credentials \
    --id $YC_K8S_CLUSTER_ID \
    --external \
    --kubeconfig ~/.kube/config.yaml
```

```sh
export KUBECONFIG=~/.kube/config.yaml
```

Use kubectl:

```sh
k get pods
```
