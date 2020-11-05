data "gitlab_project" "flux-repo" {
  id = var.gitlab_project_id
}

resource "gitlab_deploy_key" "flux" {
  title    = "Flux deploy key (${var.cluster_name})"
  can_push = true
  key      = var.public_key_openssh
  project  = data.gitlab_project.flux-repo[count.index].id
}
