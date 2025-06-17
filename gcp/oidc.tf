module "circleci_oidc" {
  source = "solidblocks/circleci-oidc/google"

  version         = "0.0.2"
  circleci_org_id = "71adbdf0-f90e-46e6-8cc2-09fa83fac452"
}

# Assign the 'roles/owner' role at the project level to the service account
resource "google_project_iam_member" "project_owner_binding" {
  project = google_project.cookson_pro.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${module.circleci_oidc.service_account_email}"
}

