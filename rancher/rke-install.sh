#!/bin/bash

########## NOTE ###########
# This script is designed 
# to install kubernetes using 
# RKE on a single node. 
# You will have to adapt it
# for multi-node install
###########################net.bridge.bridge-nf-call-iptables=1

# Install notes
# RKE is a kubernetes cluster bootstrapper. On the bootstraped cluster, you can after install
# rancher server to manage your kubernetes cluster.
# RKE is ideal for an high availability cluster of rancher.

# Install docker
curl https://get.docker.com | sudo bash

# Add curent user to docker group
sudo adduser $(whoami) docker

# Install RKE binary
wget https://github.com/rancher/rke/releases/download/v1.3.12/rke_linux-amd64 -O rke && chmod +x rke && sudo mv rke /usr/local/bin

# Generate ssh key
ssh-keygen -t rsa -b 4096

# Add the key in authorized_keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Helm install
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash

# Start RKE setup
rke config
rke up

# Setup configuration file
mkdir -p ~/.kube
cp kube_config_cluster.yml .kube/config

####################
# END OF SCRIPT HERE
####################

## Create helm namespace for rancher and add rancher helm repo
kubectl create namespace cattle-system
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

## Install cert-manager
# Add the Jetstack Helm repository
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.1 \
  --set installCRDs=true
# Check deployment of cert-manager
kubectl get pods --namespace cert-manager

## Install rancher
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=<domain> \
  --set replicas=1 \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=<email> \
  --set letsEncrypt.ingress.class=nginx
# Check deployment of rancher
kubectl -n cattle-system rollout status deploy/rancher
kubectl -n cattle-system get deploy rancher

## Install rancher CLI
# wget https://github.com/rancher/cli/releases/download/v2.4.13/rancher-linux-amd64-v2.4.13.tar.gz -O rancher.tar.gz
# tar -xzvf rancher.tar.gz
# sudo cp rancher-v2.4.13/rancher /usr/local/bin/
