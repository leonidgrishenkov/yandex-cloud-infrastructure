Save private and public key output for the particular service account:

```sh
t output -json | jq '."cr-sa-auth-key".value."cr-pusher"' > /tmp/cr-pusher-auth-key.json
```

```sh
yc config profile create cr-pusher
```

```sh
$ yc config set service-account-key /tmp/cr-pusher-auth-key.json
$ yc config set cloud-id $YC_CLOUD_ID
$ yc config set folder-id $YC_FOLDER_ID
```

Auth docker using key:

```sh
cat /tmp/cr-pusher-auth-key.json | docker login --username json_key --password-stdin cr.yandex
```
