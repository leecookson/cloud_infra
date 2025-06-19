resource "aws_iam_user" "terraform" {
  name = "terraform"
  tags = var.default_tags
}

resource "aws_iam_user_policy_attachment" "terraform" {
  user       = aws_iam_user.terraform.name
  policy_arn = aws_iam_policy.terraform.arn
}

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
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:CreateNetworkAcl",
          "ec2:DeleteNetworkAcl",
          "ec2:ReplaceNetworkAclAssociation"
        ],
        "Resource" : "*"
      }
    ]
  })
}

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
          "Federated" : "arn:aws:iam::021874127869:oidc-provider/oidc.circleci.com/org/${var.circleci_org_uuid}"
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
          "AWS" : "${aws_iam_user.terraform.arn}"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_backend" {
  role       = aws_iam_role.s3_backend.name
  policy_arn = aws_iam_policy.s3_backend.arn
}