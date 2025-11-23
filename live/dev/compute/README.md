
Save output ssh key after resources deploy:

```sh
terragrunt output -raw ssh_private_key > ~/.ssh/keys/yandex-cloud/yc-user-ssh-private-key

chmod 600 ~/.ssh/keys/yandex-cloud/yc-user-ssh-private-key
```
