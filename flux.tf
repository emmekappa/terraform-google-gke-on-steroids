locals {
  flux_ns = "flux"
  available_git_url = {
    "github" = "git@github.com:${var.github_org_name}/${var.github_repository_name}",
    "gitlab" = "git@gitlab.com:${var.gitlab_group_name}/${var.gitlab_repository_name}"
  }

  git_url = lookup(local.available_git_url, var.vcs_type)

  available_git_branch = {
    "github" = var.github_repository_branch
    "gitlab" = var.gitlab_repository_branch
  }
  git_branch = lookup(local.available_git_branch, var.vcs_type)
}

resource "kubernetes_namespace" "flux" {
  count = var.flux_enabled ? 1 : 0

  metadata {
    name = local.flux_ns
  }

  depends_on = [google_container_cluster.primary]
}

resource "tls_private_key" "flux" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "kubernetes_secret" "flux-git-deploy" {
  count = var.flux_enabled ? 1 : 0

  metadata {
    name      = "flux-ssh"
    namespace = local.flux_ns
  }

  type = "Opaque"

  data = {
    identity = tls_private_key.flux.private_key_pem
  }

  depends_on = [kubernetes_namespace.flux]
}


resource "helm_release" "flux" {
  count = var.flux_enabled ? 1 : 0

  name       = "flux"
  namespace  = local.flux_ns
  repository = "https://charts.fluxcd.io"
  chart      = "flux"
  #force_update = "true"
  version = "1.2.0"

  set {
    name  = "git.url"
    value = local.git_url
  }

  set {
    name  = "git.branch"
    value = local.git_branch
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
    value = kubernetes_secret.flux-git-deploy[count.index].metadata[0].name
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
  count      = var.flux_enabled ? 1 : 0
  name       = "flux-helm-operator"
  namespace  = local.flux_ns
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  #force_update = "true"
  version = "0.7.0"

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
    value = kubernetes_secret.flux-git-deploy[count.index].metadata[0].name
  }

  depends_on = [kubernetes_secret.flux-git-deploy]
}