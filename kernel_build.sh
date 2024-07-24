#!/bin/bash

source ./built/config

cd $LINUX_REPO_PATH

make -j$(nproc --all)

cd $SCRIPT_DIR
#cd $(readlink -f "${BASH_SOURCE}")
