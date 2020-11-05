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

data "google_project" "project" {}

resource "google_container_cluster" "default" {
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

  workload_identity_config {
    identity_namespace = "${data.google_project.project.project_id}.svc.id.goog"
  }

  addons_config {
    istio_config {
      disabled = var.istio_disabled
    }

    cloudrun_config {
      disabled = var.cloudrun_disabled
    }

    config_connector_config {
      enabled = var.config_connector_config_enabled
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
        oauth_scopes = concat(local.oauth_scopes, var.additional_oauth_scopes)
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

resource "google_container_node_pool" "default" {
  count      = var.default_node_pool.enabled ? 1 : 0
  name       = "${var.cluster_name}-node-pool"
  location   = var.cluster_location
  cluster    = google_container_cluster.default.name
  node_count = var.default_node_pool.initial_node_count
  provider   = google-beta

  management {
    auto_repair  = var.default_node_pool.auto_repair
    auto_upgrade = var.default_node_pool.auto_upgrade
  }

  autoscaling {
    min_node_count = var.default_node_pool.min_node
    max_node_count = var.default_node_pool.max_node
  }

  upgrade_settings {
    max_surge       = var.default_node_pool.max_surge
    max_unavailable = var.default_node_pool.max_unavailable
  }

  node_config {
    preemptible  = var.default_node_pool.preemptible_nodes
    machine_type = var.default_node_pool.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = concat(local.oauth_scopes, var.additional_oauth_scopes)
  }

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

}
