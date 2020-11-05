# terraform-google-gke-on-steroids

## Examples

### With Github repository
 
```
module "gke-on-steroids-flux-key" {
  source  = "emmekappa/gke-on-steroids/google//modules/flux-key"
  version = "0.2.0"
}

module "gke-on-steroids-github" {
  source                 = "emmekappa/gke-on-steroids/google//modules/github"
  version                = "0.2.0"
  cluster_name           = local.gke_cluster_name
  github_org_name        = "MY_ORG"
  github_repository_name = "MY_REPOSITORY"
  public_key_openssh     = module.gke-on-steroids-flux-key.public_key_openssh
}

module "gke-on-steroids" {
  source               = "emmekappa/gke-on-steroids/google"
  version              = "0.2.0"
  gcp_project_id       = var.gcp_project_id
  gcp_region           = var.gcp_region
  cluster_location     = var.gke_cluster_location
  cluster_name         = local.gke_cluster_name
  flux_path            = "k8s/${var.workspace}"
  gcp_credentials      = var.gcp_credentials
  parent_dns_zone_name = var.parent_dns_zone_name
  git_branch           = "master"
  git_http_url         = module.gke-on-steroids-github.git-http-url
  git_ssh_url          = module.gke-on-steroids-github.git-ssh-url
  private_key_pem      = module.gke-on-steroids-flux-key.private_key_pem
}
```
