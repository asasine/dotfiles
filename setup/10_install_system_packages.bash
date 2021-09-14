#!/usr/bin/env bash

if is-macos;
then
    brew update
    brew install \
        git \
        git-lfs \
        python3

else
    echo "Installing latest git from git's PPA"
    sudo add-apt-repository -y --no-update ppa:git-core/ppa
    sudo apt-get update
    sudo apt-get install -y git

    echo "Installing pip3"
    sudo apt-get -y install python3-pip
fi
