(define-module (mrh-guix home box packages)
  #:use-module (gnu)
  #:use-module (nongnu packages messaging)
  #:use-module (nongnu packages game-development))

(use-package-modules emacs
                     emacs-xyz
                     finance
                     fonts
                     games
                     gnome
                     image-viewers
                     librewolf
                     linux
                     package-management
                     password-utils
                     rsync
                     terminals
                     video
                     wm
                     xdisorg
                     xorg)

(define-public %box-home-packages
  (list
   ;; graphical env
   feh
   keepassxc
   libnotify
   librewolf
   libsteam
   mpv
   rofi
   setxkbmap
   signal-desktop
   steam-devices-udev-rules
   (specification->package "steam-nvidia")
   xrandr
   yt-dlp

   ;; fonts
   ;; might need to  run "fc-cache -vfr" to reubild font cache
   ;; emacs try (font-family-list)
   font-awesome
   font-google-noto
   font-google-noto-emoji
   font-google-noto-sans-cjk
   font-google-noto-serif-cjk
   font-juliamono
   font-hack

   ;; emacs
   emacs-next
   emacs-bluetooth
   emacs-aggressive-indent
   emacs-bluetooth
   emacs-consult
   emacs-corfu
   emacs-diredfl
   emacs-doom-modeline
   emacs-eat
   emacs-expand-region
   emacs-geiser
   emacs-geiser-guile
   emacs-gruvbox-theme
   emacs-magit
   emacs-marginalia
   emacs-markdown-mode
   emacs-orderless
   emacs-org-bullets
   emacs-org-static-blog
   emacs-ox-haunt
   emacs-paredit
   emacs-pinentry
   emacs-rainbow-delimiters
   emacs-sly
   emacs-tldr
   emacs-vertico
   emacs-wgrep

   ;; misc
   acpi
   alacritty
   dunst
   monero
   rsync
   stow
   ))
