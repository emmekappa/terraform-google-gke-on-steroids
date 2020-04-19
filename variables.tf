variable "region" {}

variable "project" {}

variable "gcp_credentials" {}

variable "cluster_location" {}

variable "cluster_name" {}

variable "istio_disabled" { default = true }

variable "cloudrun_disabled" { default = true }

variable "flux_enabled" { default = true }

variable "primary_nodes" {
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
    auto_upgrade       = false
    preemptible_nodes  = true
    machine_type       = "n1-standard-2"
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

variable "vcs_type" {
  type = string
}

# github variables
variable "github_org_name" {
  type = string
}

variable "github_repository_name" {
  type = string
}

variable "github_repository_branch" { default = "master" }

# gitlab variables
variable "gitlab_group_name" {
  type = string
}

variable "gitlab_project_name" {
  type = string
}

variable "gitlab_project_id" {
  type = number
}

variable "gitlab_repository_branch" { default = "master" }

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