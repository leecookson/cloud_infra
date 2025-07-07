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

## Core Cloud Infrastructure Resources

Mainly the root DNS zone setup is located here, as well as any global resources like an email DNS setup.

If there are core networking needs, they should go here. The philosophy is to keep critical account needs here, and for a stable project, this will change rarely.

## Environment Variables Required

- AWS_S3_BACKEND_ROLE <role-name>
- AWS_DEPLOY_ROLE <arn>
- AWS_CLI_INT_SESSION_DURATION: <seconds>

- AZURE_CLIENT_ID <guid>
- AZURE_TENANT_ID <guid>
- AZURE_SUBSCRIPTION_ID <guid>

- GOOGLE_COMPUTE_REGION
- GOOGLE_PROJECT_ID <project-name>
- GOOGLE_PROJECT_NUMBER <project-number>
- OIDC_SERVICE_ACCOUNT_EMAIL
- OIDC_WIP_PROVIDER_ID <provider-name>
- OIDC_WIP_ID <pool-name>
