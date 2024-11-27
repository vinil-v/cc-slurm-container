#!/bin/bash

# Get the hostname
hostname=$(hostname)

# Clone and install the Pyxis plugin for Slurm (Ref: https://github.com/NVIDIA/pyxis)
echo "Cloning the Pyxis repository..."
git clone https://github.com/NVIDIA/pyxis.git
cd pyxis
echo "Installing the Pyxis plugin..."
make install

# Add the Pyxis plugin path to 'plugstack.conf' (Ref: https://slurm.schedmd.com/spank.html)
plugstack_conf="/etc/slurm/plugstack.conf"
echo "Configuring plugstack.conf to include Pyxis plugin..."
cat << EOF > "$plugstack_conf"
required /usr/local/lib/slurm/spank_pyxis.so
EOF

# Check if the hostname contains "scheduler" and restart the appropriate Slurm service
if [[ "$hostname" == *scheduler* ]]; then
    echo "Hostname contains 'scheduler'. Restarting slurmctld..."
    sudo systemctl restart slurmctld
else
    echo "Hostname does not contain 'scheduler'. Restarting slurmd..."
    sudo systemctl restart slurmd
fi

echo "Slurm service restart completed."
echo "Pyxis plugin installation completed."