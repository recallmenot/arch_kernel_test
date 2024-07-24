#!/bin/bash

source ./built/config

cd $LINUX_REPO_PATH
git status

if [ ! -f $LINUX_REPO_PATH/tools/include/linux/panic.h ]; then
	echo "panic.h not found!"
	cp -v --update=none $SCRIPT_DIR/panic.h $LINUX_REPO_PATH/tools/include/linux/
fi

time make -j$(nproc --all)

cp -v $LINUX_REPO_PATH/arch/x86/boot/bzImage $SCRIPT_DIR/built/bzImage

cd $SCRIPT_DIR
#cd $(readlink -f "${BASH_SOURCE}")
