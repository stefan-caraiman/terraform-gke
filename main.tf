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
  backend "gcs" {
    bucket  = "${var.bucket_name}"
    prefix  = "/terraform.tfstate"
    project = "${var.project_name}"
  }
}

#############################################################
# Sample backend which uses Consul, can be used locally or
# for development purposes in case a Cloud storage bucket
# is not available. Don't forget to comment the previous backend.
#############################################################

# terraform {
#   backend "consul" {
#     address = "127.0.0.1:8500"
#     path    = "/terraform.tfstate"
#     gzip    = true
#   }
# }

resource "google_container_cluster" "gcp_kubernetes" {
  name               = "${var.cluster_name}"
  zone               = "${var.region}"
  initial_node_count = "${var.gcp_cluster_count}"

  master_auth {
    username = "${var.linux_admin_username}"
    password = "${var.linux_admin_password}}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels {
      this-is-for = "dev-cluster"
    }

    tags = ["dev", "work"]
  }
}

output "gcp_cluster_endpoint" {
  value = "${google_container_cluster.gcp_kubernetes.endpoint}"
}

output "gcp_ssh_command" {
  value = "ssh ${var.linux_admin_username}@${google_container_cluster.gcp_kubernetes.endpoint}"
}

output "gcp_cluster_name" {
  value = "${google_container_cluster.gcp_kubernetes.name}"
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.gcp_kubernetes.master_auth.0.cluster_ca_certificate}"
}
