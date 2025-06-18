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

variable "circleci_deploy_project_ids" {
  type = list(string)
  default = [
    "fe1807b9-f7cf-4aef-9e4d-a89f3399c478",
    "7d9508ea-a237-473b-b8b8-4d83c623d0e7",
    "faa383a8-cc40-4ff1-8427-9d788ac3681b"
  ]
}