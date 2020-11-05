output "kubernetes_host" {
  value = "https://${google_container_cluster.default.endpoint}"
}

output "kubernetes_cluster_ca_certificate" {
  value = base64decode(google_container_cluster.default.master_auth[0].cluster_ca_certificate)
}

output "flux_public_key" {
  value = tls_private_key.flux.public_key_openssh
}
