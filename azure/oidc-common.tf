data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_resource_group" "current" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = var.azure_owner_id
}

resource "azurerm_role_assignment" "azuread_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Domain Services Contributor"
  principal_id         = var.azure_owner_id
}
