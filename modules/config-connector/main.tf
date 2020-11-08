locals {
  //  service_account_email    = google_service_account.config_connector.email
  service_account_email    = "${var.service_account_name}@${var.gcp_project_id}.iam.gserviceaccount.com"
  k8s_namespace            = "cnrm-system"
  k8s_service_account_name = "cnrm-controller-manager"
}

resource "google_service_account" "config_connector" {
  account_id   = var.service_account_name
  display_name = "config_connector binding for ${var.service_account_name}"

}

resource "google_project_iam_member" "config_connector_owner" {
  member = "serviceAccount:${google_service_account.config_connector.email}"
  role   = "roles/owner"
}

resource "google_service_account_iam_member" "config_connector_workloadIdentityUser" {
  member             = "serviceAccount:${var.gcp_project_id}.svc.id.goog[${local.k8s_namespace}/${local.k8s_service_account_name}]"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.config_connector.name
}

resource "helm_release" "config-connector" {
  name      = "config-connector-activation"
  chart     = format("%s/chart", path.module)
  namespace = var.config_connector_namespace
  set {
    name  = "googleServiceAccount"
    value = google_service_account.config_connector.email
  }
  //  values = [
  //    templatefile(format("%s/templates/values.yaml.tpl", path.module),
  //      { "contexts" : google_service_account.config_connector.email }
  //    )
  //  ]
}
