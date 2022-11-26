#!/usr/bin/env bash
set -euo pipefail
# Getting list of IP Address from gcp cloud
gcloud compute instances  list --format="json" | jq '.[] | .networkInterfaces[0] | .accessConfigs[] | .natIP' > hosts

# Getting variable with list of ip for loop
vm_ip=$(cat hosts)

# get a counter for a loop that is equal to the number of lines in the file
vm_count=$(wc -l < hosts)

# create begin of json file
echo '{ "all": { "hosts": { ' > json_inventory/inv.json 

for count_VM in $vm_ip
do
# In cycle create list of hosts in json file
    if [[ $vm_count-1 -ne 0 ]]
    then
        echo "$count_VM: null, " >> json_inventory/inv.json
        vm_count=$((vm_count-1))
    else
# If it is last IP in list, then complete json file
        echo "$count_VM: null}}}" >> json_inventory/inv.json
    fi
done
