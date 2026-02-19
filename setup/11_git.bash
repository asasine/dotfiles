#!/usr/bin/env bash

if is-macos;
then
    brew update
    brew install \
        git \
        git-lfs

else
    echo "Installing latest git from git's PPA"
    sudo add-apt-repository -y --no-update ppa:git-core/ppa
    id=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    codename=$(lsb_release -cs)
    sudo update-repo git-core-$id-ppa-$codename.sources
    sudo apt-get install -y git
fi
