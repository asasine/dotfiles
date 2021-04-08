#!/bin/bash

# link install files to ~
base_dir="install"
echo "Linking dotfiles from $base_dir to ~"
for file in $(ls -A $base_dir); do
    # check if file already exists and its not a symlink
    if [ -f ~/$file -a ! -h ~/$file ]; then
        echo "Moving ~/$file to ~/$file.bak"
        mv -v ~/$file{,.bak}
    fi

    echo "Creating symlink to $base_dir/$file in home directory."
    ln -svf ~/dotfiles/$base_dir/$file ~/$file
done

# link config directories to ~/.config
base_dir="config"
echo
echo "Linking config files from $base_dir to ~/.$base_dir"
for file in $(ls -A $base_dir); do
    if [ -d ~/.$base_dir/$file -a ! -h ~/.$base_dir/$file ]; then
        echo "Moving ~/.$base_dir/$file to ~/.$base_dir/$file.bak"
        mv -v ~/.$base_dir/$file{,.bak}
    fi

    echo "Creating symlink to $base_dir/$file/ in ~/.$base_dir"
    ln -svf ~/dotfiles/$base_dir/$file ~/.$base_dir/$file
done

# run scripts in setup
base_dir="setup"
echo
echo "Running all executable scripts in $base_dir"
for file in $(ls -A $base_dir); do
    if [ -x $base_dir/$file ]
    then
        echo "Running ./$base_dir/$file"
        ./$base_dir/$file
    else
        echo "$base_dir/$file is not executable"
    fi
done

unset base_dir
unset file
