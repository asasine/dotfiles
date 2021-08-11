#!/usr/bin/env bash
echo "Installing latest git from git's PPA"
sudo add-apt-repository -y --no-update ppa:git-core/ppa
sudo apt-get update
sudo apt-get install -y git

echo "Installing Python3 packages"
pip3 install -U quantiphy pyperclip
