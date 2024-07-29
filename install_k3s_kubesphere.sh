#!/bin/bash

# Update and upgrade the system
apt update && apt upgrade -y

# Install curl
apt install curl -y

# Install K3s
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.23.13+k3s1" sh -

# Verify K3s installation
/usr/local/bin/k3s --version

# Wait for K3s to be fully up and running
sleep 30

# Verify K3s nodes
kubectl get nodes

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Verify Helm installation
helm version

# Add Kubesphere Helm repository and update
helm repo add kubesphere https://charts.kubesphere.io/main
helm repo update

# Apply Kubesphere installer
kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.4.1/kubesphere-installer.yaml

# Apply Kubesphere cluster configuration
kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.3.0/cluster-configuration.yaml

echo "K3s and Kubesphere installation complete."
