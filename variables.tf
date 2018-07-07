variable "project_name" {
  type        = "string"
  description = "Name of the project."
}

variable "bucket_name" {
  type        = "string"
  description = "Name of the Cloud Storage bucket used for saving the terraform state."
}

variable "region" {
  type        = "string"
  description = "Name of the region in which resources will be created."
}

variable "linux_admin_username" {
  type        = "string"
  description = "User name for authentication to the Kubernetes linux agent virtual machines in the cluster."
}

variable "linux_admin_password" {
  type        = "string"
  description = "The password for the Linux admin account."
}

variable "gcp_cluster_count" {
  type        = "string"
  description = "Count of cluster instances to start."
}

variable "cluster_name" {
  type        = "string"
  description = "Cluster name for the GCP Cluster."
}
