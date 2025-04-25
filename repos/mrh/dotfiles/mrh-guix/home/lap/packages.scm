(define-module (mrh-guix home lap packages)
  #:use-module (gnu)
  #:use-module (nongnu packages messaging)
  #:use-module (mrh packages))

(use-package-modules admin
                     aspell
                     base
                     compression
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
                     guile
                     guile-xyz
                     haskell-xyz
                     imagemagick
                     image-viewers
                     kde-plasma
                     librewolf
                     linux
                     mail
                     mp3
                     networking
                     package-management
                     password-utils
                     readline
                     rsync
                     terminals
                     texlive
                     version-control
                     video
                     wm
                     xdisorg)

(define-public %lap-home-packages
  (list
   ;; graphical-env
   alacritty
   brightnessctl
   fnott
   fuzzel
   gtk+
   libnotify
   librewolf
   sway
   swaybg
   swayidle
   swaylock
   waybar
   wf-recorder
   wl-clipboard
   xdg-utils

   ;; fonts
   ;; might need to  run "fc-cache -vfr" to reubild font cache
   ;; emacs try (font-family-list)
   font-awesome
   font-google-noto
   font-google-noto-emoji
   font-google-noto-sans-cjk
   font-google-noto-serif-cjk

   ;; media
   blueman
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
   emacs-disable-mouse
   emacs-eat
   emacs-ef-themes
   emacs-elfeed
   emacs-geiser
   emacs-geiser-guile
   emacs-htmlize
   emacs-jack
   emacs-magit
   emacs-marginalia
   emacs-markdown-mode
   emacs-moody
   emacs-orderless
   emacs-org-bullets
   emacs-org-static-blog
   emacs-paredit
   emacs-pinentry
   emacs-rainbow-delimiters
   emacs-sly
   emacs-tldr
   emacs-trashed
   emacs-vertico
   emacs-wgrep
   emacs-writeroom
   mrh-emacs-nerd-icons-dired

   ;; programming
   git
   (list git "send-email")
   gnu-make

   ;; guile
   guile-next
   guile-swayer
   guile-taglib

   ;; communication
   isync
   mu
   signal-desktop

   ;; security
   gnupg
   ksshaskpass
   pinentry-tty

   ;; misc
   cups
   fastfetch
   (list glib "bin")
   ispell
   keepassxc
   monero
   pandoc
   rlwrap
   rsync
   socat
   stow
   texlive
   unzip
   ))
