variable "terraform_backend_bucket_name" {
  type    = string
  default = "cookson-pro-tf-backend"
}

variable "terraform_backend_dynamo_table_name" {
  type    = string
  default = "cookson-pro-tf-backend"
}

variable "circleci_org_uuid" {
  type = string
}

variable "default_tags" {
  type = map(any)
  default = {
    "terraform" = "true",
    "project"   = "cloud_infra"
  }
}

variable "circleci_deploy_role_name" {
  type    = string
  default = "circle_ci_deploy"

}