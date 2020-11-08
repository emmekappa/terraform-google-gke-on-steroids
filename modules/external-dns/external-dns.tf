resource "google_service_account" "external_dns" {
  account_id   = var.service_account_name
  display_name = "external-dns binding for ${var.service_account_name}"
}

resource "google_project_iam_member" "config_connector_owner" {
  member = "serviceAccount:${google_service_account.external_dns.email}"
  role   = "roles/dns.admin"
}

resource "google_service_account_iam_member" "config_connector_workloadIdentityUser" {
  member             = "serviceAccount:${var.gcp_project_id}.svc.id.goog[${local.k8s_namespace}/${local.k8s_service_account_name}]"
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.external_dns.name
}

resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = local.k8s_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["fluxcd.io/sync-checksum"],
      metadata[0].labels["fluxcd.io/sync-gc-mark"],
    ]
  }
}

resource "helm_release" "external-dns" {
  chart        = "external-dns"
  repository   = "https://charts.bitnami.com/bitnami"
  name         = "external-dns"
  namespace    = local.k8s_namespace
  version      = "3.7.0"
  force_update = true

  set {
    name  = "provider"
    value = "google"
  }

  set {
    name  = "google.project"
    value = var.gcp_project_id
  }

  //  set {
  //    name  = "google.serviceAccountSecret"
  //    value = kubernetes_secret.external_dns_service_account_secret.metadata[0].name
  //  }

  set {
    name  = "domainFilters"
    value = "{${local.default_domain_filter}}"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = local.k8s_service_account_name
  }

  set {
    name  = "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"
    value = google_service_account.external_dns.email
    type  = "string"
  }

  set {
    name  = "logLevel"
    value = "debug"
  }
}

