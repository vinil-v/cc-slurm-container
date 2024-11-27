#!/bin/bash
# Adding CycleCloud user to docker group for running docker commands
# This script is intended to be run as a post-install script in a CycleCloud cluster
#apt-get install -y jq
for USER in $( jetpack users --json | jq -r '.[].name' ); do
echo "Adding user: ${USER}"
usermod -a -G docker ${USER};
done
newgrp docker
systemctl restart docker
