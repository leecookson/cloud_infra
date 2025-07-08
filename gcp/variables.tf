variable "project_id" {
  type = string
}
variable "billing_account_id" {
  type = string
}
variable "gcp_credentials_file" {
  description = "Path to the GCP credentials file for OIDC integration."
  type        = string
}

variable "circleci_org_uuid" {
  type = string
}

variable "gitlab_group" {
  type = string
}
variable "gitlab_project_id" {
  type = number
}