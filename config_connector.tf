resource "google_service_account" "config_connector" {
  account_id = "${var.cluster_name}-cnrm"
  display_name = "Service account for Config Connector on ${var.cluster_name} cluster"
}

resource "google_project_iam_member" "config_connector_owner" {
  member = "serviceAccount:${google_service_account.config_connector.email}"
  role = "roles/owner"
}

resource "google_service_account_iam_member" "config_connector_workloadIdentityUser" {
  member = "serviceAccount:${var.gcp_project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
  role = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.config_connector.account_id
}
