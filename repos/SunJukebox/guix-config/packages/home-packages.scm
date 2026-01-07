(define-module (anon home home-conf)
  #:use-module (gnu)
  #:use-module(guix)
  #:use-module (nongnu packages editors)

  #:use-module (anon packages fonts)
  ;; #:use-module (anon packages neovim)
  #:use-module (anon packages texlab)
  #:use-module (anon packages textutils)

  #:export (%wm-packages
            ))

(use-package-modules admin
                     chromium
                     compression
                     cups
                     ebook
                     fcitx5
                     fonts
                     freedesktop
                     glib
                     gnome
                     gnupg
                     image
                     image-viewers
                     inkscape
                     kde-graphics
                     kde-multimedia
                     librewolf
                     linux
                     node
                     package-management
                     password-utils
                     pdf
                     pulseaudio
                     qt
                     shells
                     shellutils
                     sync
                     terminals
                     tree-sitter
                     video
                     vim
                     web-browsers
                     wm
                     xdisorg
                     xorg)

(define %wm-packages
  (list sway
        swayidle
        swaylock
        foot
        fuzzel
        mako
        grimshot
        slurp
        waybar
        kanshi
        brightnessctl))
  ;; wofi
  ;; bemenu))
