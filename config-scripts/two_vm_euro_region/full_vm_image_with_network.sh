#!/usr/bin/env bash
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
project="$(gcloud projects list --format=json | jq '.[0] | .projectId' --raw-output)"
gcloud compute --project="$project" firewall-rules create tcp --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0
gcloud compute --project="$project" firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
gcloud beta compute routes create default --project="$project" --network=default --priority=1000 --destination-range=0.0.0.0/0 --next-hop-gateway=default-internet-gateway
packer build -var-file="$SCRIPT_PATH"/../../packer/two_vm_euro_region/variables.json  "$SCRIPT_PATH"/../../packer/two_vm_euro_region/app.json
packer build -var-file="$SCRIPT_PATH"/../../packer/two_vm_euro_region/variables.json  "$SCRIPT_PATH"/../../packer/two_vm_euro_region/db.json
gcloud compute firewall-rules delete tcp
gcloud compute firewall-rules delete allow-default-ssh-connect
