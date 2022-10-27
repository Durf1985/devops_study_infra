#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt -y upgrade
sudo apt install -y ruby-bundler build-essential

sudo add-apt-repository ppa:brightbox/ruby-ng-experimental
sudo apt-get update
sudo apt install -y ruby2.3 ruby2.3-dev

ruby -v
bundler -v
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
