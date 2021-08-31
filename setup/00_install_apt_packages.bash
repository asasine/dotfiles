#!/usr/bin/env bash
echo "Installing latest git from git's PPA"
sudo add-apt-repository -y --no-update ppa:git-core/ppa
sudo apt-get update
sudo apt-get install -y git

echo "Installing pip3"
sudo apt-get -y install python3-pip
