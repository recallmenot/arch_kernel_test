#!/bin/bash

source ./built/config

if [[ $GUEST_DISK_TYPE == "p" ]]; then
	disk_command="-drive format=raw,file=$GUEST_DISK_PATH,media=disk,if=none,id=root_disk,cache=none"
else
	disk_command="-drive format=qcow2,file=$GUEST_DISK_PATH,media=disk,if=none,id=root_disk,cache=none"
fi

if [[ $PCIE_ENABLE == "y" ]]; then
	pcie_addr=$(lspci -n -d $PCIE_VEN_DEV | cut -d' ' -f1)
	pcie_command="-device vfio-pci,host=$pcie_addr"
else
	pcie_command=''
fi

qemu-system-x86_64 \
	-enable-kvm \
	-m 4G \
	-smp cores=4,threads=2,sockets=1,maxcpus=8 \
	$disk_command \
	-device ahci,id=ahcibus \
	-device ide-hd,drive=root_disk,bus=ahcibus.0 \
	-initrd "$SCRIPT_DIR/built/initramfs.img" \
	-kernel "$SCRIPT_DIR/built/bzImage" \
	-append "root=UUID=$ROOT_UUID" \
	$pcie_command  \



	#-vga qxl \
	#-display gtk,gl=on,zoom-to-fit=off \
	#-nographic \
	#-append "root=UUID=a03bcef6-dee0-4de3-a505-f0c684cb3824 loglevel=3 console=ttyS0" \

	#-usb \
	#-device usb-mouse \


	#-append "root=PARTUUID=8a05e362-a2d1-4f58-a484-ad770a11ae46 crypto=" \
	#-drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.fd \
	#-drive if=pflash,format=raw,file=/home/a/VM/arch_intenso//OVMF_VARS.fd \
	#-append "root=UUID=ed067494-ffb0-429b-9b26-ee4502ed2b39 rw rootflags=rw,realtime,compress=zstd:3,discard=async,space_cache=v2,subvolid=256,subvol=@ rootfstype=btrfs loglevel=3" \
	#-append "root=UUID=ed067494-ffb0-429b-9b26-ee4502ed2b39 rw rootflags=subvol=@ rootfstype=btrfs loglevel=3" \
	#-append "root=PARTUUID=8a05e362-a2d1-4f58-a484-ad770a11ae46 rw rootflags=rw,realtime,compress=zstd:3,discard=async,space_cache=v2,subvolid=256,subvol=@ rootfstype=btrfs loglevel=3" \
	#-append "root=UUID=ed067494-ffb0-429b-9b26-ee4502ed2b39 rw rootflags=rw,realtime,compress=zstd:3,discard=async,space_cache=v2,subvolid=256,subvol=@ rootfstype=btrfs loglevel=3" \
	#-S \
	#-s \
	#-device virtio-serial,packed=on,ioeventfd=on \
	#-device virtserialport,name=com.redhat.spice.0,chardev=vdagent0 \
	#-chardev qemu-vdagent,id=vdagent0,name=vdagent,clipboard=on,mouse=off \
	#-device virtserialport,chardev=qemu-ga-925,name=org.qemu.guest_agent.0 \
	#-chardev socket,path=/tmp/qemu-ga-925.sock,server=on,wait=off,id=qemu-ga-925 \
	#-device usb-tablet \
	#-net none \



	#-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
	#-machine type=pc-q35-8.0,accel=kvm,kernel_irqchip=on \


	#
	#-device virtio-net-pci,netdev=user.0 \
	#-netdev user,hostfwd=tcp:127.0.0.1:50022-:22,id=user.0 \
	#-vga qxl \
	#-display gtk,gl=on,zoom-to-fit=off \




