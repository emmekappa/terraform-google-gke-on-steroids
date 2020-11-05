resource "google_service_account" "config_connector" {
  count        = var.config_connector_config_enabled ? 1 : 0
  account_id   = "${var.cluster_name}-cnrm"
  display_name = "Service account for Config Connector on ${var.cluster_name} cluster"
}

resource "google_project_iam_member" "config_connector_owner" {
  count  = var.config_connector_config_enabled ? 1 : 0
  member = "serviceAccount:${google_service_account.config_connector[count.index].email}"
  role   = "roles/owner"
}

resource "google_service_account_iam_member" "config_connector_workloadIdentityUser" {
  count              = var.config_connector_config_enabled ? 1 : 0
  member             = "serviceAccount:${var.gcp_project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager]"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.config_connector[count.index].account_id
}
