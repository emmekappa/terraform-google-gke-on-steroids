variable "config_connector_namespace" {
  type        = string
  description = "The namespace to install the config connector helm release into"
  default     = "configconnector-operator-system"
}

variable "gcp_project_id" {
}

variable "service_account_name" {
  description = "Used for GCP service account and KSA"
}
