output "kubernetes_host" {
  value = "https://${google_container_cluster.primary.endpoint}"
}

output "kubernetes_cluster_ca_certificate" {
  value = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}