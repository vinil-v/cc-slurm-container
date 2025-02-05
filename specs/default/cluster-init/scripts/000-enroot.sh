#!/bin/bash
apt update
apt install -y git gcc make libcap2-bin libtool automake
arch=$(dpkg --print-architecture)
curl -fSsL -O https://github.com/NVIDIA/enroot/releases/download/v3.5.0/enroot_3.5.0-1_${arch}.deb
sudo apt install -y ./*.deb
apt install -y curl gawk jq squashfs-tools parallel libfuse3-dev squashfuse fuse-overlayfs


git clone --recurse-submodules https://github.com/NVIDIA/enroot.git
cd enroot
make install

make setcap

echo 'ENROOT_RUNTIME_PATH /mnt/scratch/$(id -un)/enroot/run' > /usr/local/etc/enroot/enroot.conf
echo 'ENROOT_CONFIG_PATH /mnt/scratch/$(id -un)/enroot/config' >> /usr/local/etc/enroot/enroot.conf
echo 'ENROOT_CACHE_PATH /mnt/scratch/$(id -un)/enroot/cache' >> /usr/local/etc/enroot/enroot.conf
echo 'ENROOT_DATA_PATH /mnt/scratch/$(id -un)/enroot/data' >> /usr/local/etc/enroot/enroot.conf
echo 'ENROOT_TEMP_PATH /mnt/scratch/$(id -un)/enroot' >> /usr/local/etc/enroot/enroot.conf

