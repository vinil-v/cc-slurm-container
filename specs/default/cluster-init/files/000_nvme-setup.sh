#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function setup_nvme_disks() {

    # If /mnt/nvme is already mounted then return
    grep -qs '/mnt/nvme ' /proc/mounts && return

    NVME_DISKS_NAME=`ls /dev/nvme*n1`
    NVME_DISKS=`ls -latr /dev/nvme*n1 | wc -l`

    logger -s "Number of NVMe Disks: $NVME_DISKS"

    if [ "$NVME_DISKS" == "0" ]
    then
        exit 0
    else
        mkdir -p /mnt/nvme
        # Needed incase something did not unmount as expected. This will delete any data that may be left behind
        mdadm  --stop /dev/md*
        mdadm --create /dev/md12 -f --run --level 0 --name nvme --raid-devices $NVME_DISKS $NVME_DISKS_NAME
        mkfs.xfs -f /dev/md12
        mount /dev/md12 /mnt/nvme || exit 1
    fi

    chmod 1777 /mnt/nvme
    logger -s "/mnt/nvme mounted"
}

#if is_compute; then
    setup_nvme_disks
#fi