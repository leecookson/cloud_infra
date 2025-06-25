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