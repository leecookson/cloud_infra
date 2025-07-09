variable "azure_subscription_id" {
  type = string
}

variable "azure_owner_id" {
  type = string
}

variable "circleci_org_id" {
  type = string
}

variable "circleci_project_id" {
  type = string
}

variable "circleci_user_id" {
  type = string
}

# Need list of all project IDs for the 
variable "circleci_all_project_ids" {
  type = list(string)
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
}

variable "gitlab_all_project_ids" {
  description = "List of all GitLab project IDs for OIDC integration."
  type        = list(string)
}

variable "gitlab_branch" {
  description = "The branch to use for GitLab OIDC integration."
  type        = string
  default     = "main"
}
