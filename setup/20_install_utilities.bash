#!/usr/bin/env bash

if ! is-macos;
then
    sudo apt-get install -y \
        colorized-logs \
        tree
fi

cargo install --locked spongebob ripgrep
