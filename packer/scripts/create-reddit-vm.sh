#!/usr/bin/env bash
PROJECT="clgcporg2-057"
ZONE="us-central1-a"
gcloud compute instances create reddit \
--project=$PROJECT \
--zone=$ZONE \
--machine-type=e2-medium \
--network-interface=network-tier=PREMIUM,subnet=default \
--maintenance-policy=MIGRATE \
--provisioning-model=STANDARD \
--service-account=1000679461287-compute@developer.gserviceaccount.com \
--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
--tags=puma-server,http-server,https-server \
--create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/$PROJECT/global/images/reddit-base-1663670675,mode=rw,size=20,type=projects/$PROJECT/zones/$ZONE/diskTypes/pd-balanced \
--no-shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--reservation-affinity=any
