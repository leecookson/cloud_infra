resource "google_dns_managed_zone" "gcp_cookson_pro" {
  name        = "gcp-cookson-pro-zone"
  dns_name    = "gcp.cookson.pro."
  description = "Cookson.Pro GCP DNS zone"
  project     = google_project.cookson_pro.project_id
}

output "name_servers" {
  value = google_dns_managed_zone.gcp_cookson_pro.name_servers
}
