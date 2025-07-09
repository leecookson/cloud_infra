module "circleci-oidc-provider" {
  depends_on             = [aws_iam_policy.terraform]
  source                 = "jaconi-io/circleci-oidc-provider/aws"
  version                = "0.0.1"
  circleci_role_name     = var.circleci_deploy_role_name
  circleci_org_uuid      = var.circleci_org_uuid
  circleci_project_uuids = ["*"]

  circleci_oidc_role_attach_policies = [
    aws_iam_policy.terraform.arn
  ]

}

output "circleci_oidc_provider_arn" {
  value = module.circleci-oidc-provider.oidc_provider_arn
}

output "circleci_oidc_role" {
  value = module.circleci-oidc-provider.oidc_role
}

module "gitlab-oidc-provider" {
  depends_on = [aws_iam_policy.terraform]
  source     = "terraform-module/gitlab-oidc-provider/aws"
  version    = "1.0.1"

  create_oidc_provider = true
  create_oidc_role     = true

  repositories              = ["project_path:leecookson-group/cloud_infra", "project_path:leecookson-group/site_infra"]
  oidc_role_attach_policies = [aws_iam_policy.terraform.arn]
}

output "gitlab_oidc_provider_arn" {
  value = module.gitlab-oidc-provider.oidc_provider_arn
}
output "gitlab_oidc_role" {
  value = module.gitlab-oidc-provider.oidc_role
}