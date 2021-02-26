#!/bin/bash

# link install files to ~
for file in $(ls -A install); do
    # check if file already exists and its not a symlink
    if [ -f ~/$file -a ! -h ~/$file ]; then
        echo "Moving ~/$file to ~/$file.bak"
        mv -v ~/$file{,.bak}
    fi

    echo "Creating symlink to install/$file in home directory."
    ln -svf ~/dotfiles/install/$file ~/$file
done

# link config directories to ~/.config
for file in $(ls -A config); do
    if [ -d ~/.config/$file -a ! -h ~/.config/$file ]; then
        echo "Moving ~/.config/$file to ~/.config/$file.bak"
        mv -v ~/.config/$file{,.bak}
    fi

    echo "Creating symlink to config/$file/ in ~/.config"
    ln -svf ~/dotfiles/config/$file ~/.config/$file
done

unset $file
