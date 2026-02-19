#!/usr/bin/env bash
echo "Installing Python3 packages"

if is-macos;
then
    python3 -m pip install -U \
        click \
        more_itertools \
        pyperclip \
        python-dateutil \
        quantiphy \
        rich
fi