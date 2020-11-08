variable "flux_path" {
  description = "Flux base path related to repository root (i.e. 'k8s/')."
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
  default     = "1.2.0"
  description = "Flux helm operator chart version  https://github.com/fluxcd/helm-operator/tree/master/chart/helm-operator"
}

variable "flux_chart_version" {
  default     = "1.5.0"
  description = "Flux chart version https://github.com/fluxcd/flux/tree/master/chart"
}
