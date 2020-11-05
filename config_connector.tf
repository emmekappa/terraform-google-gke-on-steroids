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
  service_account_id = google_service_account.config_connector[count.index].name
}

//resource "kubernetes_manifest" "config_connector" {
//  count    = var.config_connector_config_enabled ? 1 : 0
//  provider = kubernetes-alpha
//  manifest = {
//    apiVersion = "core.cnrm.cloud.google.com/v1beta1"
//    kind       = "ConfigConnector"
//    metadata = {
//      # the name is restricted to ensure that there is only one
//      # ConfigConnector instance installed in your cluster
//      name = "configconnector.core.cπnrm.cloud.google.com"
//    }
//    spec = {
//      mode                 = "cluster"
//      googleServiceAccount = google_service_account.config_connector[count.index].email
//    }
//  }
//  depends_on = [google_service_account.config_connector]
//}
