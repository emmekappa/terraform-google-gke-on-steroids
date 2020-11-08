variable "dns_zone" {
  description = "The DNS zone to create under parent_dns_zone_name"
}

variable "gcp_project_id" {
}

variable "parent_dns_zone_name" {
}

variable "service_account_name" {
  description = "Used for GCP service account and KSA"
}
