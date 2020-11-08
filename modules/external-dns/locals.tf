locals {
  k8s_namespace            = "external-dns"
  default_domain_filter    = replace(local.k8s_dns_name, "/\\.$/", "")
  k8s_dns_name             = "${var.dns_zone}.${data.google_dns_managed_zone.env_dns_parent_zone.dns_name}"
  k8s_service_account_name = "external-dns"
}
