#!/usr/bin/env bash

if ! is-macos;
then
    echo 'Skipping on non-macOS platforms'
    exit 0
fi

if is-supported brew --version;
then
    echo 'Homebrew already installed'
    exit 0
fi

echo 'Installing homebrew'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
