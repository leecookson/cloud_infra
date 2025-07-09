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

variable "circleci_all_project_ids" {
  type        = list(string)
  description = "List of CircleCI project IDs"
  validation {
    condition     = length(var.circleci_all_project_ids) > 0
    error_message = "At least one CircleCI project ID must be provided."
  }
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
}

variable "gitlab_all_project_ids" {
  type        = list(string)
  description = "List of GitLab repo IDs"
  validation {
    condition     = length(var.gitlab_all_project_ids) > 0
    error_message = "At least one GitLab repo must be provided."
  }
}

variable "gitlab_branch" {
  description = "The branch to use for GitLab OIDC integration."
  type        = string
  default     = "main"
}
