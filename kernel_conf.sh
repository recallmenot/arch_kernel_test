#!/bin/bash

source ./built/config

cd $LINUX_REPO_PATH

make menuconfig

cd $SCRIPT_DIR
#cd $(readlink -f "${BASH_SOURCE}")
