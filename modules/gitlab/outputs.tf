output "git-ssh-url" {
  value = "git@gitlab.com:${var.gitlab_group_name}/${var.gitlab_project_name}"
}
