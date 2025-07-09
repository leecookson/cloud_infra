data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_resource_group" "current" {
  name = var.resource_group_name
}

# These don't "create" the roles, but they activate them and allow us to retrieve their IDs
resource "azuread_directory_role" "app_administrator" {
  display_name = "Application Administrator"
}
resource "azuread_directory_role" "app_developer" {
  display_name = "Application Developer"
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
