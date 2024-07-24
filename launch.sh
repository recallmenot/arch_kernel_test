#!/bin/bash

source ./built/config

qemu-system-x86_64 \
	-enable-kvm \
	-m 4G \
	-smp cores=4,threads=2,sockets=1,maxcpus=8 \
	-drive format=raw,file=/dev/disk/by-id/usb-Intenso_High_Speed_Line_12210600003542-0:0,media=disk,if=none,id=ts_usb,cache=none \
	-device ahci,id=ahcibus \
	-device ide-hd,drive=ts_usb,bus=ahcibus.0 \
	-initrd "$SCRIPT_DIR/built/initramfs.img" \
	-kernel "$SCRIPT_DIR/built/bzImage" \
	-append "root=UUID=a03bcef6-dee0-4de3-a505-f0c684cb3824" \
	-usb \
	-device usb-mouse \
	-device vfio-pci,host=04:00.0 \



	#-vga qxl \
	#-display gtk,gl=on,zoom-to-fit=off \
	#-nographic \
	#-append "root=UUID=a03bcef6-dee0-4de3-a505-f0c684cb3824 loglevel=3 console=ttyS0" \



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




