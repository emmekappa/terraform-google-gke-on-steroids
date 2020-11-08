locals {
  flux_ns = "flux"
}

resource "kubernetes_namespace" "flux" {
  metadata {
    name = local.flux_ns
  }
}

resource "kubernetes_secret" "flux-git-deploy" {
  metadata {
    name      = "flux-ssh"
    namespace = local.flux_ns
  }

  type = "Opaque"

  data = {
    identity = var.private_key_pem
  }

  depends_on = [kubernetes_namespace.flux]
}

resource "helm_release" "flux" {
  name       = "flux"
  namespace  = local.flux_ns
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  #force_update = "true"
  version = var.flux_chart_version

  set {
    name  = "git.url"
    value = var.git_ssh_url
  }

  set {
    name  = "git.branch"
    value = var.git_branch
  }

  set {
    name  = "git.path"
    value = var.flux_path
  }

  set {
    name  = "git.pollInterval"
    value = var.flux_git_poll_interval
  }

  set {
    name  = "git.timeout"
    value = var.flux_git_timeout
  }

  set {
    name  = "git.ciSkip"
    value = "true"
  }

  set {
    name  = "git.secretName"
    value = kubernetes_secret.flux-git-deploy.metadata[0].name
  }

  set {
    name  = "syncGarbageCollection.enabled"
    value = var.flux_garbage_collection_enabled
  }

  dynamic "set" {
    for_each = var.fluxcloud_enabled ? [1] : []
    content {
      name  = "additionalArgs"
      value = "{--connect=ws://fluxcloud}"
    }
  }

  depends_on = [kubernetes_secret.flux-git-deploy]
}

resource "helm_release" "flux-helm-operator" {
  name       = "flux-helm-operator"
  namespace  = local.flux_ns
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  #force_update = "true"
  version = var.flux_helm_operator_chart_version

  set {
    name  = "createCRD"
    value = "false"
  }

  set {
    name  = "git.pollInterval"
    value = var.flux_git_poll_interval
  }

  set {
    name  = "git.timeout"
    value = var.flux_git_timeout
  }

  set {
    name  = "helm.versions"
    value = "v3"
  }

  set {
    name  = "git.ssh.secretName"
    value = kubernetes_secret.flux-git-deploy.metadata[0].name
  }

  depends_on = [kubernetes_secret.flux-git-deploy]
}
