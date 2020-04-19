data "gitlab_project" "flux-repo" {
  count = var.vcs_type == "gitlab" ? 1 : 0
  id    = var.gitlab_project_id
}

resource "gitlab_deploy_key" "flux" {
  count    = var.vcs_type == "gitlab" ? 1 : 0
  title    = "Flux deploy key (${var.cluster_name})"
  can_push = true
  key      = tls_private_key.flux.public_key_openssh
  project  = data.gitlab_project.flux-repo[count.index].id
}