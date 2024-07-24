#!/bin/bash

echo "enter the UUID of the guest root partition by running sudo blkid:"
read root_uuid
echo "export ROOT_UUID='$root_uuid'" >> built/config
