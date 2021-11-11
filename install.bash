#!/bin/bash



READLINK=$(which greadlink 2>/dev/null || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" && $machine != 'Unknown' ]]; then
  if [[ $machine == 'Linux' ]]; then
    SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  elif [[ $machine == 'Mac' ]]; then
    SCRIPT_PATH=$($READLINK "$CURRENT_SCRIPT")
  fi

  DOTFILES_DIR=$($READLINK -m $(dirname "$(dirname "$SCRIPT_PATH")"))
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
elif [ -d "$HOME/dotfiles" ]; then
  DOTFILES_DIR="$HOME/dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

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
    ln -svf $DOTFILES_DIR/$base_dir/$file ~/$file
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
    mkdir -p ~/.$base_dir

    # -s: symbolic
    # -v: verbose
    # -f: force (delete if LINK_NAME already exists)
    # -n: don't dereference LINK_NAME if it's a symlink to a directory
    #   -n is necessary to avoid recursively linking to config/git/git/git/...
    ln -svfn $DOTFILES_DIR/$base_dir/$file ~/.$base_dir/$file
done

# source new bashrc
source ~/.bashrc

# run scripts in setup
base_dir="setup"
echo
echo "Running all executable scripts in $base_dir"
for file in $(ls -A $base_dir); do
    echo
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
