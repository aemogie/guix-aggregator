# Set up the system, user profile, and related variables.
source /etc/profile
# Set up the home environment profile.
source ~/.profile
# It's only necessary if zsh is a login shell, otherwise profiles will
# be already sourced by bash

# Merge search-paths from multiple profiles, the order matters.
eval "$(guix package --search-paths \
-p $HOME/.config/guix/current \
-p $HOME/.guix-profile \
-p /run/current-system/profile)"

export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale
export PATH="$HOME/.npm-global/bin:$PATH"
# export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:$XDG_DATA_DIRS
export GUIX_PACKAGE_PATH=$HOME
export GUILE_LOAD_PATH=$HOME

GUIX_PROFILE="$HOME/.guix-profile"
source "$GUIX_PROFILE/etc/profile"

GUIX_PROFILE="$HOME/.config/guix/current"
source "$GUIX_PROFILE/etc/profile"

# Prepend setuid programs.
export PATH=/run/setuid-programs:$PATH

source $HOME/.profile
