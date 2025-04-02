(define-module (mrh-guix home lap packages)
  #:use-module (gnu)
  #:use-module (nongnu packages messaging)
  #:use-module (mrh packages))

(use-package-modules admin
                     aspell
                     base
                     compression
                     cpp
                     cups
                     emacs
                     emacs-xyz
                     finance
                     fonts
                     freedesktop
                     glib
                     gnome
                     gnupg
                     gtk
                     guile-xyz
                     haskell-xyz
                     imagemagick
                     image-viewers
                     kde-plasma
                     libreoffice
                     librewolf
                     linux
                     lisp
                     lisp-xyz
                     mail
                     mp3
                     networking
                     package-management
                     password-utils
                     python
                     pdf
                     readline
                     rsync
                     sdl
                     statistics
                     terminals
                     ;; texlive
                     version-control
                     video
                     wm
                     xdisorg)

(define-public %lap-home-packages
  (list
   ;; graphical-env
   alacritty
   blueman
   brightnessctl
   fnott
   fuzzel
   gtk+
   guile-swayer
   libnotify
   libreoffice
   librewolf
   sway
   swaybg
   swayidle
   swaylock
   waybar
   wf-recorder
   wl-clipboard
   xdg-utils
   zoom

   ;; fonts
   ;; might need to  run "fc-cache -vfr" to reubild font cache
   ;; emacs try (font-family-list)
   font-awesome
   font-google-noto
   font-google-noto-emoji
   font-google-noto-sans-cjk
   font-google-noto-serif-cjk
   font-hack

   ;; media
   ffmpeg
   grimshot
   imagemagick
   imv
   mpv
   yt-dlp

   ;; emacs
   emacs-pgtk
   emacs-aggressive-indent
   emacs-auctex
   emacs-bluetooth
   emacs-buffer-env
   emacs-consult
   emacs-corfu
   emacs-debbugs
   emacs-diredfl
   emacs-doom-modeline
   emacs-eat
   emacs-geiser
   emacs-geiser-guile
   emacs-gruvbox-theme
   emacs-ligature
   emacs-magit
   emacs-marginalia
   emacs-markdown-mode
   emacs-nerd-icons
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

   ;; programming
   git
   (list git "send-email")
   gnu-make
   hut

   ;; C
   ccls

   ;; lisp
   cl-alexandria
   cl-csv
   cl-dexador
   cl-jzon
   cl-ppcre
   cl-quri
   cl-serapeum
   cl-taglib
   lem-next
   mrh-coleslaw
   sbcl

   ;; communication
   signal-desktop

   ;; mail
   isync
   mu

   ;; security
   gnupg
   ksshaskpass
   pinentry-tty

   ;; misc
   cups
   fastfetch
   (list glib "bin")
   haunt
   ispell
   keepassxc
   monero
   pandoc
   rlwrap
   rsync
   socat
   stow
   ;; texlive
   unzip
   ))
