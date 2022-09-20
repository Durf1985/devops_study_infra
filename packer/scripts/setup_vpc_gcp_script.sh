#!/usr/bin/env bash
project="clgcporg2-057"
PRIVATE_KEY_DIR=$(dirname $(realpath "TXT.pub"))
gcloud compute --project=$project firewall-rules create tcp --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0
gcloud compute --project=$project firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
gcloud beta compute routes create default --project=$project --network=default --priority=1000 --destination-range=0.0.0.0/0 --next-hop-gateway=default-internet-gateway
gcloud compute project-info add-metadata --metadata-from-file=ssh-keys=$PRIVATE_KEY_DIR/TXT.pub
