#!/usr/bin/env bash
set -euo pipefail
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
packer build -var-file="$SCRIPT_PATH"/packer/two_vm_ansible_provisioner/variables.json  "$SCRIPT_PATH"/packer/two_vm_ansible_provisioner/app.json
packer build -var-file="$SCRIPT_PATH"/packer/two_vm_ansible_provisioner/variables.json  "$SCRIPT_PATH"/packer/two_vm_ansible_provisioner/db.json
