#!/usr/bin/env bash
set -euo pipefail
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
packer build -var-file="$SCRIPT_PATH"/packer/variables.json  "$SCRIPT_PATH"/packer/app.json
packer build -var-file="$SCRIPT_PATH"/packer/variables.json  "$SCRIPT_PATH"/packer/db.json
