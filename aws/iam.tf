data "aws_caller_identity" "current" {}

# For local use, to allow a static credential user to deploy Terraform
resource "aws_iam_user" "terraform" {
  name = "terraform"
  tags = var.default_tags
}

# Core terraform permissions
resource "aws_iam_policy" "terraform" {
  name = "TerraformDeploy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      },
      {
        "Effect" : "Deny",
        "Action" : [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:ModifyVpcAttribute",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:ModifySubnetAttribute",
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:ReplaceRouteTableAssociation",
          "ec2:CreateNetworkAcl",
          "ec2:DeleteNetworkAcl",
          "ec2:ReplaceNetworkAclAssociation"
        ],
        "Resource" : "*"
      }
    ]
  })
}

#attach the terraform permissions policy to the user
resource "aws_iam_user_policy_attachment" "terraform" {
  user       = aws_iam_user.terraform.name
  policy_arn = aws_iam_policy.terraform.arn
}

# to allow a role-based deployment for local deployment
resource "aws_iam_role" "TerraformDeploy" {
  name = "TerraformDeploy"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${aws_iam_user.terraform.arn}"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "TerraformDeploy" {
  role       = aws_iam_role.TerraformDeploy.name
  policy_arn = aws_iam_policy.terraform.arn
}

data "aws_ssoadmin_instances" "all" {}

resource "aws_iam_policy" "s3_backend" {
  name = "TerraformS3Backend"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${module.s3_backend.s3_backend_bucket_id}",
          "arn:aws:s3:::${module.s3_backend.s3_backend_bucket_id}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:ConditionCheckItem"
        ],
        "Resource" : [
          "arn:aws:dynamodb:::${module.s3_backend.state_lock_dynamodb_table_id}",
          "arn:aws:dynamodb:::${module.s3_backend.state_lock_dynamodb_table_id}/*"
        ]
      }
    ]
  })
}
resource "aws_iam_role" "s3_backend" {
  name = "s3_backend"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${module.circleci-oidc-provider.oidc_provider_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "oidc.circleci.com/org/${var.circleci_org_uuid}:sub" : "org/${var.circleci_org_uuid}/project/*/user/*"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${module.gitlab-oidc-provider.oidc_provider_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "gitlab.com:sub" : [
              "project_path:leecookson-group/*"
            ]
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${aws_iam_user.terraform.arn}"
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${module.github-oidc-provider.oidc_provider_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:leecookson/*:ref:refs/heads/main"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          # The OIDC provider for AWS SSO/Identity Center.
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/sso.us-east-1.amazonaws.com/d-906637c9b5"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "sso.us-east-1.amazonaws.com/d-906637c9b5:sub" : "repo:leecookson/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_backend" {
  role       = aws_iam_role.s3_backend.name
  policy_arn = aws_iam_policy.s3_backend.arn
}

output "TerraformDeployRoleArn" {
  value = aws_iam_role.TerraformDeploy.arn
}