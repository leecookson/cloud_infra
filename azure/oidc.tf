data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_resource_group" "current" {
  name = var.resource_group_name
}

# az ad sp create-for-rbac --name "circleci-sp" --skip-assignment
resource "azuread_application" "circleci" {
  display_name = "circleci-oidc-app"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "circleci" {
  client_id                    = azuread_application.circleci.client_id
  app_role_assignment_required = false
  owners = [
    data.azuread_client_config.current.object_id
  ]
}

resource "azuread_application_federated_identity_credential" "circleci_oidc" {
  for_each       = toset(var.circleci_all_project_ids)
  application_id = "/applications/${azuread_application.circleci.object_id}"
  display_name   = "circleci-oidc-${each.value}"
  issuer         = "https://oidc.circleci.com/org/${var.circleci_org_id}"
  subject        = "org/${var.circleci_org_id}/project/${each.value}/user/${var.circleci_user_id}"
  audiences      = [var.circleci_org_id]
}
# az role assignment create \
#   --assignee <sp-object-id> \
#   --role "Contributor" \
#   --scope /subscriptions/<subscription-id>/resourceGroups/<your-rg>
resource "azurerm_role_assignment" "circleci_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = split("/", azuread_service_principal.circleci.id)[2]
}

resource "azurerm_role_assignment" "circleci_azuread_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Domain Services Contributor"
  principal_id         = split("/", azuread_service_principal.circleci.id)[2]
}

resource "azurerm_role_assignment" "owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = var.azure_owner_id
}

resource "azurerm_role_assignment" "asuread_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Domain Services Contributor"
  principal_id         = var.azure_owner_id
}

output "circleci_client_id" {
  description = "Application Tenant ID configured in Azure"
  value       = azuread_application.circleci.client_id
}

output "oidc_application" {
  value = azuread_application.circleci.id
}

output "federated_subject" {
  description = "OIDC subject configured in Azure"
  value       = { for k, v in azuread_application_federated_identity_credential.circleci_oidc : k => v.subject }
}

output "tenant_id" {
  description = "Tenant ID configured in Azure"
  value       = data.azuread_client_config.current.tenant_id
}

output "service_principal" {
  description = "Azure Service Pricipal"
  value       = azuread_service_principal.circleci.id
}