locals {
  external_dns_namespace = "external-dns"
  default_domain_filter  = replace(local.k8s_dns_name, "/\\.$/", "")
}

resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = local.external_dns_namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["fluxcd.io/sync-checksum"],
      metadata[0].labels["fluxcd.io/sync-gc-mark"],
    ]
  }

  depends_on = [google_container_cluster.default]
}

resource "google_service_account" "external_dns" {
  account_id   = "e-dns-${var.cluster_name}"
  project      = var.project
  display_name = "external-dns-${var.cluster_name}"
}

resource "google_service_account_key" "external_dns" {
  service_account_id = google_service_account.external_dns.name
}

resource "google_project_iam_member" "external_dns_dns_admin" {
  provider = google-beta
  project  = var.project
  role     = "roles/dns.admin"
  member   = "serviceAccount:${google_service_account.external_dns.email}"
}

resource "kubernetes_secret" "external_dns_service_account_secret" {
  metadata {
    name      = "external-dns-service-account"
    namespace = local.external_dns_namespace
  }

  type = "Opaque"

  data = {
    "credentials.json" = base64decode(google_service_account_key.external_dns.private_key)
  }

  depends_on = [google_container_cluster.default]
}

resource "helm_release" "external-dns" {
  chart        = "external-dns"
  repository   = "https://charts.bitnami.com/bitnami"
  name         = "external-dns"
  namespace    = local.external_dns_namespace
  force_update = true
  version      = "2.20.5"

  set {
    name  = "provider"
    value = "google"
  }

  set {
    name  = "google.project"
    value = var.project
  }

  set {
    name  = "google.serviceAccountSecret"
    value = kubernetes_secret.external_dns_service_account_secret.metadata[0].name
  }

  set {
    name  = "domainFilters"
    value = "{${local.default_domain_filter}}"
  }
}
