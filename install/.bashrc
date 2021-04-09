
# heavily inspired by https://github.com/webpro/dotfiles/blob/master/runcom/.bash_profile

# debug to /tmp/timestamps to investigate slow startup
DEBUG=false # set to true to debug
if $DEBUG
then
  echo 'Debugging timestamps. View at /tmp/timestamps'
  if [ -f /tmp/timestamps ];
  then
    mv -fv /tmp/timestamps /tmp/timestamps.old
  fi

  exec 5> >(ts -i "%.s" >> /tmp/timestamps)
  export BASH_XTRACEFD="5"

  # enable tracing
  set -x
fi

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
for DOTFILE in .{env,aliases,prompt,completion}; do
    SYSTEM_DOTFILE=$DOTFILES_DIR/system/$DOTFILE
    if [ -f $SYSTEM_DOTFILE ]; then
        source $SYSTEM_DOTFILE
    fi

    LOCAL_DOTFILE=$HOME/$DOTFILE.local
    if [ -f $LOCAL_DOTFILE ]; then
        source $LOCAL_DOTFILE
    fi
done

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE
export DOTFILES_DIR
source "$HOME/.cargo/env"

if $DEBUG
then
  # disable tracing
  set +x
fi
