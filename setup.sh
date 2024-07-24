#!/bin/bash

rm -rf built
mkdir built
touch built/config

echo "export SCRIPT_DIR='$(readlink -f $(dirname $0))'" >> built/config

echo "enter the path to your local copy of the linux repository:"
read linux_repo_path
echo "export LINUX_REPO_PATH='$linux_repo_path'" >> built/config

echo "do you want to use a qcow2 image or a physical disk for the guest?"
echo "press q for qcow2 or p for physical"
while true; do
	read -n 1 key
	if [[ $key =~ ^[qp]$ ]]; then
		guest_disk_type=$key
		break
	fi
done
echo
echo "export GUEST_DISK_TYPE='$guest_disk_type'" >> built/config

echo "enter the path to the guest storage image / disk:"
read guest_disk_path
echo "export GUEST_DISK_PATH='$guest_disk_path'" >> built/config

echo "do you want to test a physical PCIe device inside the VM? y/n"
while true; do
	read -n 1 key
	if [[ $key =~ ^[yn]$ ]]; then
		break
	fi
done
echo
if [[ $key == "y" ]]; then
	echo "export PCIE_ENABLE='y'" >> built/config
	lspci -nn
	echo "enter the vendor:device ID string of the device (e.g. 104c:823f):"
	read pcie_ven_dev
	echo "export PCIE_VEN_DEV='$pcie_ven_dev'" >> built/config
fi

echo "do you want to use an ISO to install the guest OS? y/n"
while true; do
	read -n 1 key
	if [[ $key =~ ^[yn]$ ]]; then
		break
	fi
done
echo
if [[ $key == "y" ]]; then
	echo "export ISO_ENABLE='y'" >> built/config
	echo "enter the ISO path:"
	read iso_path
	echo "export ISO_PATH='$iso_path'" >> built/config
fi

cp -v /usr/share/edk2-ovmf/x64/OVMF_VARS.fd ./built/
cp -v ./mkinitcpio.conf ./built/
