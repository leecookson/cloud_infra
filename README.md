## Triple-Platform Cloud Infrastruture

Uses the repo [TF-Scripts](https://github.com/leecookson/tf-scripts) to perform the terraform init, backend setup and specific operations like plan, apply, destroy, state and import

## Overall Auth Model

Goal: Support a simple local development model, while also enforcing secure CI/CD platform deployments.

- Local Dev: use "secured" static credentials or native web-based auth for testing deployments locally

  - AWS: Use a 1Password plugin with static credentials
  - Azure: Use web-based auth, depending on secure web authentication using MFA and/or passkeys
  - GCP: Use web-based auth, similar to azure

- For CI/CD (Initially only CircleCI) - see each `oidc.tf` file
  - AWS: Supports wildcard subjet matching, so one IAM federated credential is needed, and a module that abstracts this to only the circleCI orgID is used.
  - Azure: This one is tricky since the federated credential doesn't support pattern-matching on the subject yet, so have to deploy one OIDC connection per CircleCI Project, and all Project IDs have to be manually configured in the terraform configuration.
  - GCP: Similar to AWS, GCP supports a wildcard, and a terraform module abstracts this.
