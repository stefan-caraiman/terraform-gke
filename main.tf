#############################################################
# Defining the Google provider and GCS backend used
# for storing the state of the Terraform infrastructure.
############################################################

provider "google" {
  credentials = "${file("account.json")}"
  project     = "${var.project_name}"
  region      = "${var.region}"
}

terraform {
  required_version = ">= 0.11.7"

  backend "gcs" {
    bucket  = "terraform-gke-209511-bucket"
    prefix  = "/terraform.tfstate"
    project = "terraform-gke-209511"
  }
}

#############################################################
# Sample backend which uses Consul, can be used locally or
# for development purposes in case a Cloud storage bucket
# is not available. Don't forget to comment the previous backend.
#############################################################

# For development purposes, consul can simply be start with
# "consul agent -dev"

# terraform {
#   backend "consul" {
#     address = "127.0.0.1:8500"
#     path    = "/terraform.tfstate"
#     gzip    = true
#   }
# }

resource "google_container_cluster" "gcp_kubernetes" {
  name                     = "${var.cluster_name}"
  zone                     = "${var.region}"
  initial_node_count       = "${var.gcp_cluster_count}"
  remove_default_node_pool = true

  master_auth {
    username = "${var.linux_admin_username}"
    password = "${var.linux_admin_password}}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "primary_pool" {
  name       = "${google_container_cluster.gcp_kubernetes.name}-primary-pool"
  cluster    = "${google_container_cluster.gcp_kubernetes.name}"
  zone       = "${var.region}"
  node_count = "3"

  node_config {
    machine_type = "${var.machine_size}"
  }

  autoscaling {
    min_node_count = 3
    max_node_count = 5
  }
}

############################################################
# Output variables of the resources
############################################################

output "gcp_cluster_endpoint" {
  value = "${google_container_cluster.gcp_kubernetes.endpoint}"
}

output "gcp_ssh_command" {
  value = "ssh ${var.linux_admin_username}@${google_container_cluster.gcp_kubernetes.endpoint}"
}

output "gcp_cluster_name" {
  value = "${google_container_cluster.gcp_kubernetes.name}"
}

output "client_certificate" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.cluster_ca_certificate}"
}
