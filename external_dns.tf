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

resource "helm_release" "external-dns" {
  chart        = "external-dns"
  repository   = "https://charts.bitnami.com/bitnami"
  name         = "external-dns"
  namespace    = local.external_dns_namespace
  version      = "3.5.1"
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
}
