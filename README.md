# terraform-gke

# About:

This repository contains all the necessary code for setting up a kubernetes cluster within Google Kubernetes Engine(GKE).

# Prerequisites for setting up the cluster:

* terraform, version 0.11.7


# Initializing Helm server(Tiller) on the Kubernetes cluster

# Notes:

1. In case the provider does not see the "account.json" local file, try exporting the file location like such: ```export GOOGLE_CREDENTIALS="account.json"```