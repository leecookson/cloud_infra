module "circleci_oidc" {
  source = "solidblocks/circleci-oidc/google"

  version         = "0.0.2"
  circleci_org_id = var.circleci_org_uuid
}

# Assign the 'roles/owner' role at the project level to the service account
resource "google_project_iam_member" "circle_ci_deploy" {
  project = google_project.cookson_pro.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${module.circleci_oidc.service_account_email}"
}

# Get the Workload Identity Pool Provider resource name for GitLab CI configuration
output "circleci-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.circleci_oidc.workload_identity_pool_provider_id
}

