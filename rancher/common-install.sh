#!/bin/bash

# sudo apt update ; sudo apt install -y ntp nfs-common open-iscsi ; curl https://get.docker.com | bash ; sudo adduser $(whoami) docker

sudo apt update

sudo apt install -y ntp nfs-common open-iscsi

curl https://get.docker.com | bash

sudo adduser $(whoami) docker
