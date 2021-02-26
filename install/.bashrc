
# heavily inspired by https://github.com/webpro/dotfiles/blob/master/runcom/.bash_profile

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

READLINK=$(which greadlink 2>/dev/null || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
elif [ -d "$HOME/dotfiles" ]; then
  DOTFILES_DIR="$HOME/dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# utilities
PATH="$DOTFILES_DIR/bin:$PATH"

# source the dotfiles (order matters)
for DOTFILE in $DOTFILES_DIR/system/.{env,aliases,prompt,completion}; do
    if [ -f $DOTFILE ]; then
        source $DOTFILE
    fi
done

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE
export DOTFILES_DIR
