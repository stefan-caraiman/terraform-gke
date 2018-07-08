# terraform-gke

# About:

This repository contains all the necessary code for setting up a kubernetes cluster within Google Kubernetes Engine(GKE).

# Prerequisites for setting up the cluster:

* terraform, version 0.11.7
* kubectl
* helm
* gcloud 

# Initializing Helm server(Tiller) on the Kubernetes cluster

```
gcloud container clusters get-credentials terraform-gke-cluster --zone europe-west4-a

kubectl create serviceaccount tiller --namespace kube-system

kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller

# Check if tiller is running
kubectl get pods -n kube-system
```
Installing Nginx

```
helm install stable/nginx-ingress --namespace kube-system --set controller.hostNetwork=true,controller.kind=DaemonSet
```

# Notes:

1. In case the provider does not see the "account.json" local file, try exporting the file location like such: ```export GOOGLE_CREDENTIALS="account.json"```