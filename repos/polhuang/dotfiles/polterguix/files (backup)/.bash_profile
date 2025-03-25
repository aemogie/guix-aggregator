# Merge search-paths from multiple profiles, the order matters.
eval "$(guix package --search-paths \
-p $HOME/.config/guix/current \
-p $HOME/.guix-profile \
-p /run/current-system/profile)"

export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale
export PATH="$HOME/.npm-global/bin:$PATH"
# export XDG_DATA_DIRS=/var/lib/flatpak/exports/share:$XDG_DATA_DIRS
export POLTEST="nice"
export GUIX_PACKAGE_PATH=$HOME

GUIX_PROFILE="/home/polhuang/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

GUIX_PROFILE="/home/polhuang/.config/guix/current"
. "$GUIX_PROFILE/etc/profile"

# Prepend setuid programs.
export PATH=/run/setuid-programs:$PATH

source $HOME/.profile
