# augment PATH with nix profile
export PATH=$HOME/.nix-profile/bin:$PATH

# add nix directory to XDG_DATA_DIRS
export XDG_DATA_DIRS="$HOME/.local/share:$HOME/.nix-profile/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"

# many build scripts expect CC to contain compiler command
export CC="gcc"
