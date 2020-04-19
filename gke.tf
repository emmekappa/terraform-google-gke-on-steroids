locals {
  oauth_scopes = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append"
  ]
}
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location
  provider = google-beta

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  logging_service          = "logging.googleapis.com/kubernetes"
  min_master_version       = var.min_master_version

  release_channel {
    channel = var.release_channel
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    istio_config {
      disabled = var.istio_disabled
    }

    cloudrun_config {
      disabled = var.cloudrun_disabled
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance_window_time
    }
  }

  dynamic "cluster_autoscaling" {
    for_each = var.cluster_autoscaling.enabled ? [var.cluster_autoscaling] : []
    content {
      enabled             = cluster_autoscaling.value.enabled
      autoscaling_profile = cluster_autoscaling.value.autoscaling_profile

      auto_provisioning_defaults {
        oauth_scopes = local.oauth_scopes
      }

      resource_limits {
        resource_type = "cpu"
        minimum       = cluster_autoscaling.value.cpu_min
        maximum       = cluster_autoscaling.value.cpu_max
      }

      resource_limits {
        resource_type = "memory"
        minimum       = cluster_autoscaling.value.ram_min
        maximum       = cluster_autoscaling.value.ram_max
      }
    }
  }

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  count      = var.primary_nodes.enabled ? 1 : 0
  name       = "${var.cluster_name}-node-pool"
  location   = var.cluster_location
  cluster    = google_container_cluster.primary.name
  node_count = var.primary_nodes.initial_node_count
  provider   = google-beta

  management {
    auto_repair  = var.primary_nodes.auto_repair
    auto_upgrade = var.primary_nodes.auto_upgrade
  }

  autoscaling {
    min_node_count = var.primary_nodes.min_node
    max_node_count = var.primary_nodes.max_node
  }

  upgrade_settings {
    max_surge       = var.primary_nodes.max_surge
    max_unavailable = var.primary_nodes.max_unavailable
  }

  node_config {
    preemptible  = var.primary_nodes.preemptible_nodes
    machine_type = var.primary_nodes.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = local.oauth_scopes
  }

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

}