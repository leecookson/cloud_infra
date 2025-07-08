# GCP Cloud Infrastructure

## Install GCloud

https://cloud.google.com/sdk/docs/install

terraform provider will detect the installed `gcloud` CLI and use it to retrieve credentials.
You will login to the CLI with `gcloud auth application-default login`

## General Usage

As with the other platforms, core DNS zone config and OIDC are configured here. Additionally, since GCP requires specific API's to be enabled manually before they are used, the [`projects.tf`](./projects.tf) file does this automatically.
