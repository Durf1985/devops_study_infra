#!/usr/bin/env bash
project="clgcporg2-100"
SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "$(basename $0)"
gcloud compute --project=$project firewall-rules create tcp --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:22 --source-ranges=0.0.0.0/0
gcloud compute --project=$project firewall-rules create default-puma-server --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:9292 --source-ranges=0.0.0.0/0 --target-tags=puma-server
gcloud beta compute routes create default --project=$project --network=default --priority=1000 --destination-range=0.0.0.0/0 --next-hop-gateway=default-internet-gateway
gcloud compute project-info add-metadata --metadata-from-file=ssh-keys=/home/fallgeratoor/gcloud-script/TXT.pub
gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1804-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --restart-on-failure \
  --zone us-west1-a \
  --tags puma-server \
  --metadata-from-file=startup-script=$SCRIPT_DIR/deploy.sh 
  