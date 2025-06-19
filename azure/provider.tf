terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

# export ARM_USE_MSI=true
# export ARM_SUBSCRIPTION_ID=159f2485-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# export ARM_TENANT_ID=72f988bf-xxxx-xxxx-xxxx-xxxxxxxxxxxx
provider "azurerm" {
  features {}
}
