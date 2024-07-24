#!/bin/bash

source ./built/config

cd $LINUX_REPO_PATH
make modules_install -j$(nproc --all)

cd $SCRIPT_DIR
fakeroot sh -c 'mkinitcpio -k $SCRIPT_DIR/built/bzImage -c $SCRIPT_DIR/built/mkinitcpio.conf -g $SCRIPT_DIR/built/initramfs.img'

