variable "github_org_name" {
  description = "Github owner or organization"
}

variable "github_repository_name" {
  description = "Github repository"
}

variable "public_key_openssh" {
  description = "Flux public key"
}

variable "cluster_name" {
  description = "Name of k8s cluster (in order to name the deploy key)"
}
