(use-modules (gnu packages))

(specifications->manifest
 '("cl-alexandria" "cl-ppcre" "cl-slynk" "cl-bordeaux-threads" "cl-cffi" "cl-usocket"
   ;; Fonts
   "font-ibm-plex" "font-dejavu" "font-liberation"
   "font-abattis-cantarell" "font-wqy-microhei" "font-hack"
   "font-gnu-unifont"
   "font-google-material-design-icons"
   ;; GuixSD essentials and other mandatory packages
   "libfixposix" "nss-certs"
   ;; Xorg utilities
   "xrdb" "xev" "xfontsel" "xmodmap" "xset" "xsetroot" "xinit" "xinput" "xcape"
   "xclip" "xdg-utils" "xrandr" "xgamma" "feh" "pulseaudio" "pamixer"
   ;; Bluetooth
   "bluez" "blueman"
   ;; Readline and shell helpers.
   "readline" "rlwrap"
   ;; CLI utils and other necessary things.
   "p7zip" "dosfstools" "file" "tree" "zip" "unzip" "git" "sysfsutils"
   "gnupg" "pinentry" "emacs-pinentry" "perl" "stapler"
   "unrar" ; NON-FREE
   ;; Games
   "dwarf-fortress" "ioquake3" "openmw" "minetest" "chocolate-doom"
   ;; Useful everyday programs.
   "libreoffice" "keepassxc" "rxvt-unicode" "vlc" "pavucontrol" "pamixer"
   "openvpn" "electrum" "openssh" "w3m"))
