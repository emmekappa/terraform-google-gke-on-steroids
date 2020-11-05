variable "gcp_region" {
  description = "Google Cloud Platform region"
}

variable "gcp_project_id" {
  description = "Google Cloud Platform project"
}

variable "gcp_credentials" {
  description = "Google Cloud Platform service credential json"
}

variable "cluster_location" {
  description = "Google Kubernetes Engine cluster location"
}

variable "cluster_name" {
  description = "Google Kubernetes Engine cluster name"
}

variable "istio_disabled" { default = true }

variable "cloudrun_disabled" { default = true }

variable "flux_enabled" { default = true }

variable "config_connector_config_enabled" { default = false }

variable "additional_oauth_scopes" {
  type    = list(string)
  default = []
}

variable "default_node_pool" {
  type = object({
    enabled            = bool,
    initial_node_count = number
    min_node           = number
    max_node           = number
    max_surge          = number
    max_unavailable    = number
    auto_repair        = bool
    auto_upgrade       = bool
    preemptible_nodes  = bool
    machine_type       = string
  })
  default = {
    enabled            = true
    initial_node_count = 1
    min_node           = 1
    max_node           = 1
    max_surge          = 1
    max_unavailable    = 0
    auto_repair        = true
    auto_upgrade       = true
    preemptible_nodes  = true
    machine_type       = "e2-standard-2"
  }
}

variable "enable_vertical_pod_autoscaling" {
  default = false
}

variable "cluster_autoscaling" {
  type = object({
    enabled             = bool
    autoscaling_profile = string
    cpu_min             = number
    cpu_max             = number
    ram_min             = number
    ram_max             = number
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    cpu_min             = 1
    cpu_max             = 4
    ram_min             = 1
    ram_max             = 8
  }
}

variable "flux_path" {
  description = "Flux base path related to repository root (i.e. 'k8s/')."
}

variable "parent_dns_zone_name" {
  description = "Parent dns zone name"
}

variable "dns_name" {
  description = "Managed dns to create, will be relative to parent_dns_zone_name, if not specified cluster_name will be used"
  default     = ""
}

variable "daily_maintenance_window_time" {
  default = "02:00"
}

variable "min_master_version" {
  default = ""
}

variable "flux_garbage_collection_enabled" {
  default = "false"
}

variable flux_git_timeout {
  default = "5m"
}

variable flux_git_poll_interval {
  default = "1m"
}

# Flux cloud

variable "fluxcloud_enabled" {
  default     = false
  description = "Enable fluxcloud installation on GKE clkuster"
}

variable "fluxcloud_slack_url" {
  description = "Slack webhook URL to use"
  default     = ""
}
variable "fluxcloud_slack_channel" {
  description = "Slack channel to send messages to"
  default     = "#kubernetes"
}
variable "fluxcloud_slack_username" {
  description = "Slack username to use when sending messages"
  default     = "fluxcloud"
}

variable "fluxcloud_github_url" {
  description = "URL to the Github repository that Flux uses, used for Slack links"
  default     = ""
}

variable "fluxcloud_slack_icon_emoji" {
  description = "Slack emoji to use as the icon"
  default     = ":arrow_right:"
}

variable "fluxcloud_chart_verion" {
  default = "0.1.2"
}

variable "release_channel" {
  default = "REGULAR"
}

variable "private_key_pem" {
  description = "Flux private key"
}

variable "git_branch" {
  description = "Git branch used by Flux"
}

variable "git_ssh_url" {
  description = "Git url in ssh scheme (used by Flux)"
}

variable "git_http_url" {
  description = "Git url in HTTP scheme"
}

variable "flux_helm_operator_chart_version" {
  default     = "0.7.0" # 1.2.0
  description = "Flux helm operator chart version  https://github.com/fluxcd/helm-operator/tree/master/chart/helm-operator"
}

variable "flux_chart_version" {
  default     = "1.2.0" # 1.5.0
  description = "Flux chart version https://github.com/fluxcd/flux/tree/master/chart"
}
