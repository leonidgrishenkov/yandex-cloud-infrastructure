In order to get list of all available images see this: <https://yandex.cloud/en/docs/compute/operations/images-with-pre-installed-software/get-list>

To get a list of available images using the CLI, run this command:

```sh
yc compute image list --folder-id standard-images
```

To get a list of IDs of available image families, run the following command:

```sh
yc compute image list \
  --folder-id standard-images \
  --limit 0 \
  --jq '.[].family' | sort | uniq
```
