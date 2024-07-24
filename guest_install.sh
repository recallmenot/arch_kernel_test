#!/bin/bash

source ./built/config

if [[ $ISO_ENABLE ]]; then
	echo 'do you want to load the ISO? y/n'
	while true; do
		read -n 1 key
		if [[ $key =~ ^[yn]$ ]]; then
			guest_disk_type=$key
			break
		fi
	done
	echo
	if [[ $key == "y" ]]; then
		iso_command="-cdrom $ISO_PATH"
	else
		iso_command=''
	fi
else
	iso_command=''
fi
echo $iso_command

if [[ $GUEST_DISK_TYPE == "p" ]]; then
	disk_command="-drive format=raw,file=$GUEST_DISK_PATH,media=disk,if=none,id=root_disk,cache=none"
else
	disk_command="-drive format=qcow2,file=$GUEST_DISK_PATH,media=disk,if=none,id=root_disk,cache=none"
fi
echo $disk_command

if [[ $PCIE_ENABLE == "y" ]]; then
	echo 'do you want to connect the PCIe device $PCIE_VEN_DEV? y/n'
	while true; do
		read -n 1 key
		if [[ $key =~ ^[yn]$ ]]; then
			break
		fi
	done
	echo
	if [[ $key == "y" ]]; then
		pcie_addr=$(lspci -n -d $PCIE_VEN_DEV | cut -d' ' -f1)
		pcie_command="-device vfio-pci,host=$pcie_addr"
	else
		pcie_command=''
	fi
else
	pcie_command=''
fi
echo $pcie_command

qemu-system-x86_64 \
	-enable-kvm \
	-m 4G \
	-smp cores=4,threads=2,sockets=1,maxcpus=8 \
	$disk_command \
	$iso_command \
	-device ahci,id=ahcibus \
	-device ide-hd,drive=root_disk,bus=ahcibus.0 \
	-drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.fd \
	-drive if=pflash,format=raw,file=$SCRIPT_DIR/built/OVMF_VARS.fd \
	$pcie_command \






	#-usb \
	#-device usb-mouse \

	#-device virtio-serial,packed=on,ioeventfd=on \
	#-device virtserialport,name=com.redhat.spice.0,chardev=vdagent0 \
	#-chardev qemu-vdagent,id=vdagent0,name=vdagent,clipboard=on,mouse=off \
	#-device virtserialport,chardev=qemu-ga-925,name=org.qemu.guest_agent.0 \
	#-chardev socket,path=/tmp/qemu-ga-925.sock,server=on,wait=off,id=qemu-ga-925 \
	#-device usb-tablet \
	#-net none \

	#-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
	#-machine type=pc-q35-8.0,accel=kvm,kernel_irqchip=on \

	#-device virtio-net-pci,netdev=user.0 \
	#-netdev user,hostfwd=tcp:127.0.0.1:50022-:22,id=user.0 \
	#-vga qxl \
	#-display gtk,gl=on,zoom-to-fit=off \




