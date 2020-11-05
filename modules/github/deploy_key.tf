data "github_repository" "flux-repo" {
  name = var.github_repository_name
}

resource "github_repository_deploy_key" "flux" {
  title      = "Flux deploy key (${var.cluster_name})"
  repository = data.github_repository.flux-repo.name
  read_only  = false
  key        = var.public_key_openssh
}
