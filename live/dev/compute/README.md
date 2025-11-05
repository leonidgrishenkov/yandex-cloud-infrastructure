
Save output ssh key after resources deploy:

```sh
terragrunt output -raw ssh_private_key > /tmp/yc-user-ssh-private-key

chmod 600 /tmp/yc-user-ssh-private-key
```
