

resource "google_project" "cookson_pro" {
  name            = "GCP Cookson-pro"
  project_id      = "cookson-pro-gcp"
  billing_account = var.billing_account_id
}

resource "google_billing_project_info" "cookson_pro" {
  project         = google_project.cookson_pro.project_id
  billing_account = var.billing_account_id
}

variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = set(string)
  default = [
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "certificatemanager.googleapis.com",
    "networkservices.googleapis.com",
    "serviceusage.googleapis.com"
  ]
}

resource "google_project_service" "cookson_pro" {
  depends_on = [google_billing_project_info.cookson_pro]
  for_each   = var.gcp_service_list

  service = each.value
  project = google_project.cookson_pro.project_id
}
