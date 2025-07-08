variable "project_id" {
  type = string
}
variable "billing_account_id" {
  type = string
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

variable "gitlab_gcp_aservice_account_name" {
  description = "The name of the GitLab GCP service account."
  type        = string
}