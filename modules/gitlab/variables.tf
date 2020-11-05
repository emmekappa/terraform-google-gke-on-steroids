variable "gitlab_project_id" {
  description = "Gitlab project ID"
}

variable "gitlab_group_name" {
  description = "Gitlab group name"
}

variable "gitlab_project_name" {
  description = "Gitlab project name"
}

variable "public_key_openssh" {
  description = "Flux public key"
}

variable "cluster_name" {
  description = "Name of k8s cluster (in order to name the deploy key)"
}

