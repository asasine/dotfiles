#!/usr/bin/env bash

if is-macos;
then
    brew update
    brew install \
        git \
        git-lfs \
        python3

else

    echo "Installing pip3"
    sudo apt-get -y install python3-pip
fi
