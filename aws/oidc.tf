module "circleci-oidc-provider" {
  source             = "jaconi-io/circleci-oidc-provider/aws"
  version            = "0.0.1"
  circleci_role_name = var.circleci_deploy_role_name
  circleci_org_uuid  = var.circleci_org_uuid
  circleci_project_uuids = var.circleci_deploy_project_ids

  circleci_oidc_role_attach_policies = [
    "arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53DomainsFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    "arn:aws:iam::aws:policy/CloudFrontFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccessV2",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess"
    # "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    # "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess",
    # "arn:aws:iam::aws:policy/AmazonSESFullAccess",
    # "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    # "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    # "arn:aws:iam::aws:policy/AWSWAFFullAccess",
  ]
}

output "circleci_oidc_role_arn" {
  value = module.circleci-oidc-provider.oidc_role
}
