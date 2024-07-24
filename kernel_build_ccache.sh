#!/bin/bash

source ./built/config

cd $LINUX_REPO_PATH

make CC="ccache gcc" -j$(nproc --all)

cd $SCRIPT_DIR
#cd $(readlink -f "${BASH_SOURCE}")
