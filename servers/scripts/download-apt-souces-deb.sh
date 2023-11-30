#!/bin/bash

# Example of command
sudo apt-get --allow-unauthenticated -y install --print-uris postgresql-15 | cut -d\' -f2 | grep http:// > /tmp/downloadlist
wget -i /tmp/downloadlist
