terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.32.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.4.0"
    }
  }
}

# export ARM_USE_MSI=true
# export ARM_SUBSCRIPTION_ID=159f2485-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# export ARM_TENANT_ID=72f988bf-xxxx-xxxx-xxxx-xxxxxxxxxxxx
provider "azurerm" {
  # When doing a plan on CirleCI, it wants to change the "owner" to the 
  # service principal, and error indicates it needs subscription_id on the provider
  # subscription_id = var.azure_subscription_id
  features {}
}
