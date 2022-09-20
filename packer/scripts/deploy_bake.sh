#!/usr/bin/env bash
set -euo pipefail
sudo apt update
sudo apt -y upgrade
sudo apt install -y ruby-bundler build-essential

sudo add-apt-repository ppa:brightbox/ruby-ng-experimental
sudo apt-get update
sudo apt install -y ruby2.3 ruby2.3-dev

wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y mongodb-org
sudo systemctl enable mongod
sudo systemctl start mongod

git clone -b monolith https://github.com/express42/reddit.git 
cd /home/appuser/
cd reddit && bundle install

cat << EOF | sudo tee -a /etc/systemd/system/monapp.service
[Unit]
Description= Launch reddit application
After=mongod

[Service]
Type=simple
WorkingDirectory=/home/appuser/reddit
ExecStart=/usr/local/bin/puma

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable monapp.service
sudo systemctl start monapp.service
sudo systemctl status monapp.service
