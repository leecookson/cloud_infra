# terraform import google_iam_workload_identity_pool.circleci circleci-deploys

resource "google_iam_workload_identity_pool" "circleci" {
  project                   = google_project.cookson_pro.project_id
  workload_identity_pool_id = "circleci-deploys"
  display_name              = "CircleCI Deploys"
  description               = "OIDC for CircleCI deploys"
}

#terraform import google_iam_workload_identity_pool_provider.circleci circleci-deploys/circleci

resource "google_iam_workload_identity_pool_provider" "circleci" {
  project                            = google_project.cookson_pro.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.circleci.workload_identity_pool_id
  workload_identity_pool_provider_id = "circleci"
  display_name                       = "CircleCI"
  attribute_mapping = {
    "google.subject"     = "assertion.sub"
    "attribute.audience" = "assertion.aud"
    "attribute.project"  = "assertion['oidc.circleci.com/project-id']"
    "attribute.context"  = "assertion['oidc.circleci.com/context-ids']"
  }
  oidc {
    issuer_uri = "https://oidc.circleci.com/org/71adbdf0-f90e-46e6-8cc2-09fa83fac452"
  }
}