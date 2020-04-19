data "github_repository" "flux-repo" {
  count = var.vcs_type == "github" ? 1 : 0
  name  = var.github_repository_name
}

resource "github_repository_deploy_key" "flux" {
  count      = var.vcs_type == "github" ? 1 : 0
  title      = "Flux deploy key (${var.cluster_name})"
  repository = data.github_repository.flux-repo[count.index].name
  read_only  = false
  key        = tls_private_key.flux.public_key_openssh
}