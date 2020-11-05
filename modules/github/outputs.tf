output "git-ssh-url" {
  value = "git@github.com:${var.github_org_name}/${var.github_repository_name}"
}

output "git-http-url" {
  value = "https://github.com/${var.github_org_name}/${var.github_repository_name}"
}
