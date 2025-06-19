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

output "circleci_oidc_role_arn" {
  value = module.circleci-oidc-provider.oidc_role
}
