locals {
  k8s_dns_name = "${var.dns_name == "" ? var.cluster_name : var.dns_name}.${data.google_dns_managed_zone.env_dns_parent_zone.dns_name}"
}
data "google_dns_managed_zone" "env_dns_parent_zone" {
  name = var.parent_dns_zone_name
}

resource "google_dns_managed_zone" "k8s-zone" {
  name        = replace(replace(local.k8s_dns_name, ".", "-"), "/-$/", "")
  dns_name    = local.k8s_dns_name
  description = "${var.cluster_name} managed zone"
}

resource "google_dns_record_set" "ns" {
  name = local.k8s_dns_name
  type = "NS"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.env_dns_parent_zone.name

  rrdatas = google_dns_managed_zone.k8s-zone.name_servers
}