# GitLab OIDC integration
resource "azuread_application" "gitlab" {
  display_name = "gitlab-oidc-app"
  owners = [
    var.azure_owner_id
  ]
}

resource "azuread_service_principal" "gitlab" {
  client_id                    = azuread_application.gitlab.client_id
  app_role_assignment_required = false
  owners = [
    var.azure_owner_id
  ]
}

resource "azuread_application_federated_identity_credential" "gitlab_oidc" {
  for_each       = toset(var.gitlab_all_project_ids)
  application_id = "/applications/${azuread_application.gitlab.object_id}"
  display_name   = "gitlab-oidc-${split("/", each.value)[1]}"
  issuer         = "https://gitlab.com"
  subject        = "project_path:${each.value}:ref_type:branch:ref:${var.gitlab_branch}"
  audiences      = ["https://gitlab.com"]
}

resource "azurerm_role_assignment" "gitlab_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.gitlab.object_id
}

resource "azurerm_role_assignment" "gitlab_ad_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Domain Services Contributor"
  principal_id         = azuread_service_principal.gitlab.object_id
}

# Required for managing Azure AD applications and service principals
resource "azuread_directory_role_assignment" "gitlab_app_admin" {
  role_id             = azuread_directory_role.app_administrator.object_id
  principal_object_id = azuread_service_principal.gitlab.object_id
}

# Alternative: More restrictive but sufficient for OIDC credentials
resource "azuread_directory_role_assignment" "gitlab_app_developer" {
  role_id             = azuread_directory_role.app_developer.object_id
  principal_object_id = azuread_service_principal.gitlab.object_id
}

output "gitlab_federated_subject" {
  description = "GitLab OIDC subject configured in Azure"
  value       = { for k, v in azuread_application_federated_identity_credential.gitlab_oidc : k => v.subject }
}

output "gitlab_tenant_id" {
  description = "GitLab Tenant ID configured in Azure"
  value       = data.azuread_client_config.current.tenant_id
}

output "gitlab_service_principal" {
  description = "GitLab Azure Service Principal"
  value       = azuread_service_principal.gitlab.id
}
