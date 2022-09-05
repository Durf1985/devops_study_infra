#!/usr/bin/env bash
host_address="35.247.59.143"
echo "$(basename $0)"
scp -i ~/.ssh/appuser install_ruby.sh appuser@"$host_address":~/
scp -i ~/.ssh/appuser install_mongodb.sh appuser@"$host_address":~/
scp -i ~/.ssh/appuser deploy.sh appuser@"$host_address":~/
