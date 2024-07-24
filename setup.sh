#!/bin/bash

rm -rf built
mkdir built
touch built/config

echo "export SCRIPT_DIR='$(readlink -f $(dirname $0))'" >> built/config

echo "enter the path to your local copy of the linux repository:"
read linux_repo_path
echo "export LINUX_REPO_PATH='$linux_repo_path'" >> built/config

echo "enter the path to the guest storage disk (/dev/disk/by-id/)"
read guest_disk
echo "export GUEST_DISK='$guest_disk'" >> built/config

cp -v /usr/share/edk2-ovmf/x64/OVMF_VARS.fd ./built/
cp -v ./mkinitcpio.conf ./built/
