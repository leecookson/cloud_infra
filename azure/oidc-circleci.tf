
# CircleCI OIDC integration
resource "azuread_application" "circleci" {
  display_name = "circleci-oidc-app"
  owners = [
    var.azure_owner_id
  ]
}

resource "azuread_service_principal" "circleci" {
  client_id                    = azuread_application.circleci.client_id
  app_role_assignment_required = false
  owners = [
    var.azure_owner_id
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

resource "azurerm_role_assignment" "circleci_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.circleci.object_id
}

resource "azurerm_role_assignment" "circleci_ad_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Domain Services Contributor"
  principal_id         = azuread_service_principal.circleci.object_id
}


# Required for managing Azure AD applications and service principals
resource "azuread_directory_role_assignment" "circleci_app_admin" {
  role_id             = azuread_directory_role.app_administrator.object_id
  principal_object_id = azuread_service_principal.circleci.object_id
}

# Alternative: More restrictive but sufficient for OIDC credentials
resource "azuread_directory_role_assignment" "circleci_app_developer" {
  role_id             = azuread_directory_role.app_developer.object_id
  principal_object_id = azuread_service_principal.circleci.object_id
}


output "circleci_client_id" {
  description = "Application Tenant ID configured in Azure"
  value       = azuread_application.circleci.client_id
}

output "circleci_oidc_application" {
  value = azuread_application.circleci.id
}

output "circleci_federated_subject" {
  description = "CircleCI OIDC subject configured in Azure"
  value       = { for k, v in azuread_application_federated_identity_credential.circleci_oidc : k => v.subject }
}

output "circleci_tenant_id" {
  description = "CircleCI Tenant ID configured in Azure"
  value       = data.azuread_client_config.current.tenant_id
}

output "circleci_service_principal" {
  description = "CircleCI Azure Service Principal"
  value       = azuread_service_principal.circleci.id
}
