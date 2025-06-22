variable "azure_subscription_id" {
  type = string
}

variable "circleci_org_uuid" {
  type = string
}

variable "circleci_project_uuid" {
  type = string
}

variable "circleci_user_uuid" {
  type = string
}

variable "resource_group_name" {
  description = "The name of the Azure Resource Group."
  type        = string
  default     = "rg-cooksonpro-site"
}