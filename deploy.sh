#!/usr/bin/env bash
set -euo pipefail
script_path=$(dirname "$(readlink -f "$0")")
project="$(grep -o 'clgcporg2....' "$script_path"/terraform/prod/terraform.tfstate | head -1)"
gcloud init
gcloud auth application-default login
replace="$(gcloud projects list --format=json | jq '.[0] | .name' --raw-output)"

sed -i 's/'"$project"'/'"$replace"'/g' "$script_path"/config-scripts/two_vm/variables.json
sed -i 's/'"$project"'/'"$replace"'/g' "$script_path"/terraform/prod/terraform.tfvars
sed -i 's/'"$project"'/'"$replace"'/g' "$script_path"/terraform/terraform.tfvars

cd "$script_path"/config-scripts/two_vm/
set +e # disable error tracking
bash full_vm_image_with_network.sh
set -e # enable error tracking
cd "$script_path"/terraform/prod
sudo rm terraform.tfstate
terraform init
terraform apply
external_ip_app="$(terraform output -raw app_external_ip)"
external_ip_db="$(terraform output -raw db_external_ip)"
cd "$script_path"/ansible
# shellcheck source=/dev/null
source venv/bin/activate

inventory_external_ip_app="$(yq -r .all.children.app.hosts.appserver.ansible_host "$script_path"/ansible/inventory.yml)"
inventory_external_ip_db="$(yq -r .all.children.db.hosts.dbserver.ansible_host "$script_path"/ansible/inventory.yml)"
sed -i 's/'"$inventory_external_ip_app"'/'"$external_ip_app"'/g' "$script_path"/ansible/inventory.yml
sed -i 's/'"$inventory_external_ip_db"'/'"$external_ip_db"'/g' "$script_path"/ansible/inventory.yml 
deactivate


# bash -x deploy.sh -строчное отображение выполнения скрипта
# export PROJdct_DIR общая переменная для скриптов вызываемых в main скрипте
