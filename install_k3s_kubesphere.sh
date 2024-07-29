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

# Get congiguration files
wget https://github.com/fek1s/configs/blob/main/cluster/cluster-configuration.yaml
wget https://github.com/kubesphere/ks-installer/releases/download/v3.4.1/kubesphere-installer.yaml

# Apply Kubesphere installer
kubectl apply -f kubesphere-installer.yaml

# Apply Kubesphere cluster configuration
kubectl apply -f cluster-configuration.yaml

echo "K3s and Kubesphere installation complete."

sleep 60 

kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f
