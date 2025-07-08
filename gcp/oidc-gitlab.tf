module "gitlab-wif" {
  source     = "Cyclenerd/wif-gitlab/google"
  version    = "~> 2.0.0"
  project_id = var.project_id
  # Restrict access to username or the name of a GitLab group
  # attribute_condition = "assertion.namespace_path=='${var.gitlab_group}'"
}

# Get the Workload Identity Pool Provider resource name for GitLab CI configuration
output "gitlab-workload-identity-provider" {
  description = "The Workload Identity Provider resource name"
  value       = module.gitlab-wif.provider_name
}

resource "google_service_account" "gitlab" {
  project      = google_project.cookson_pro.project_id
  account_id   = var.gitlab_gcp_aservice_account_name
  display_name = "GitLab Pipeline User"
}

# Allow service account to login via WIF and only from GitLab repository (project path)
module "gitlab-service-account" {
  source     = "Cyclenerd/wif-service-account/google"
  version    = "~> 1.0.0"
  project_id = google_project.cookson_pro.project_id
  pool_name  = module.gitlab-wif.pool_name
  account_id = google_service_account.gitlab.id
  repository = "${var.gitlab_group}/cloud_infra"
  depends_on = [google_service_account.gitlab]
}

# Assign the 'roles/owner' role at the project level to the service account
resource "google_project_iam_member" "gitlab" {
  project = google_project.cookson_pro.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.gitlab.email}"
}


