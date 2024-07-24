# to test a kernel

## purpose

This serves to easily test the [linux kernel](https://github.com/torvalds/linux) in a QEMU VM.

It can be used to find the commit that introduced a bug into the kernel you know was introduced e.g. between v6.9 and v6.10 by [bisecting it](https://www.kernel.org/doc/html/latest/admin-guide/bug-bisect.html).

Unlike other bisection procedures, we'll run our compiled kernel ontop of a full guest operating system, so we aren't just limited to running scripts and simple programs from the initrd.

As long as all drivers are arvailable, we can test any userspace application.

Even PCIe devices (GPUs, NICs, interface cards, audio interfaces) can be tested!

Host and guest can be Arch or any flavor thereof (Endeavour, Artix, Manjaro, etc.), though for maximum speed and access to the Arch wiki, Arch will always be recommended.

### example usecase

My usecase was bisecting a bug in the ALSA sound driver for an RME FireFace 800 audio interface connected via a TI XIO2213B FireWire 800 PCIe card.

## no modules allowed

To save on time and complexity, we won't be installing any kernel modules of our kernels-under-test into the guest.

This means that the drivers for any devices we intend on using need to be built into the kernel to be available when booted!

Luckily `make menuconfig` makes this a simple task, just press 'y' on the desired module.

In case you get a warning that this module depends on another, try building-in the parent module aswell.

Below is a list of the modules I had to build into the kernel for my usecase.

You'll need at least the file systems, the input devices, some sort of graphics driver and the one for the device you want to test.

- File Systems
    - ext3
    - ext4
    - btrfs
    - exfat
    - vfat
    - fat
    - ntfs
- Device Drivers
    - Input Device Support
        - Mouse Interface
        - Keyboards
            - AT keyboard
        - Mice
            - PS/2 mouse
    - IEEE 1394
        - FireWire driver stack
    - Graphics Support
        - Direct Rendering Manager
            - DRM support for bochs (qemu std vga)
    - Sound Card Support
        - Advanced Linux Sound Architecture
            - FireWire sound devices
                - RME Fireface

## procedure

You'll need at least 3 terminals, tmux to taste:
1. pointed at your local linux repo for running git bisect or modifying files
2. pointed at this repository to set the guest up and repeatedly compile and test
3. to bind the PCIe device under test to vfio-pci

### setup
Clone and compile the kernel.

Run `./setup.sh` to configure the scripts.

Run `./kernel_copy.sh` to retrieve the kernel.

Run `./initrd_build.sh` to install the kernels modules to the host and build the initrd we're going to use for booting the kernel on the guest.

Usually, the initrd only needs to be built once, the kernel can change.


Your guest may be either on a physical disk or in a qcow2 you created beforehand.

In the former case, use `ls /dev/disk/by-id/` to get a consistent path to the full disk.

Use `./guest_install.sh` to install and configure the guest how you would like.

In case you specified an ISO in the setup process, it will be mounted here.

Some recommendations for the guest:
- efi partition fat32
- root partition ext4
- swap isn't necessary as long as you provide enough RAM (4GB is a good size).
- packages: grub efibootmgr man-db base-devel vim coreutils e2fsprogs dosfstools networkmanager lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4 xfce4-goodies


Use `./setup_UUID.sh` to set the UUID of the root partition so the kernel will be able to find it.

To retrieve it, run `sudo blkid` inside the guest run through `./guest_install.sh`.


#### enable IOMMU passthrough on the host
`sudo nvim /etc/default/grub`

To `GRUB_CMDLINE_LINUX_DEFAULT` add `intel_iommu=on iommu=pt` or the AMD equivalent.

`sudo grub-mkconfig -o /boot/grub/grub.cfg`, reboot.

See [PCI passthrough via OVMF](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF) for more details.

### preparation
Unbind the PCIe device from its driver and bind it to vfio-pci.

An example:
```
su
lspci -nnk
echo 0000:03:00.0 > /sys/bus/pci/drivers/firewire_ohci/unbind
modprobe vfio
modprobe vfio_iommu_type1
modprobe vfio_pci
echo 0000:03:00.0 > /sys/bus/pci/drivers/vfio-pci/bind
```
### testing
Terminal #1: make your modification / bisect

Terminal #2, with `sudo -s`:
```
./kernel_build.sh
./launch.sh
```
When building the kernel, menuconfig will appear, this is intentional.

This updates the new options of the kernels .config file to their defaults so the build process can run uninterrupted.

Just save, then quit by pressing ESC twice.


Test in the guest, repeat.

Inside the guest `uname -r` should show the commit sha.
