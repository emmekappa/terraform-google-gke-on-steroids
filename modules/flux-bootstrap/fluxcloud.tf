resource "helm_release" "fluxcloud" {
  count      = var.fluxcloud_enabled ? 1 : 0
  name       = "fluxcloud"
  namespace  = local.flux_ns
  repository = "https://emmekappa.github.io/fluxcloud"
  chart      = "fluxcloud"
  version    = var.fluxcloud_chart_verion

  set {
    name  = "fluxcloud.slack.url"
    value = var.fluxcloud_slack_url
  }

  set {
    name  = "fluxcloud.slack.channel"
    value = var.fluxcloud_slack_channel
  }

  set {
    name  = "fluxcloud.slack.channel"
    value = var.fluxcloud_slack_channel
  }

  set {
    name  = "fluxcloud.slack.username"
    value = var.fluxcloud_slack_username
  }

  set {
    name  = "fluxcloud.slack.iconEmoji"
    value = var.fluxcloud_slack_icon_emoji
  }

  set {
    name  = "fluxcloud.slack.githubUrl"
    value = var.git_http_url
  }
}
