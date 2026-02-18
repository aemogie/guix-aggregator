(define-module (mrh-guix home sleep packages)
  #:use-module (gnu)
  #:use-module (mrh packages)
  #:use-module (nongnu packages messaging))

(use-package-modules admin
                     aspell
                     base
                     compression
                     cups
                     dns
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
                     lisp
                     mail
                     mp3
                     networking
                     package-management
                     password-utils
                     pdf
                     photo
                     readline
                     rsync
                     terminals
                     tex
                     tree-sitter
                     version-control
                     video
                     wm
                     xdisorg)

(define-public %sleep-home-packages
  (list
   ;; graphical-env
   brightnessctl
   fnott
   foot
   fuzzel
   gnome-themes-extra
   gsettings-desktop-schemas
   gtk+
   libnotify
   librewolf
   swayfx
   swaybg
   swayidle
   swaylock
   waybar
   wf-recorder
   wl-clipboard
   zathura
   zathura-djvu
   zathura-pdf-mupdf
   zathura-ps

   ;; fonts
   ;; might need to  run "fc-cache -vfr" to reubild font cache
   ;; emacs try (font-family-list)
   font-awesome
   font-google-noto
   font-google-noto-emoji
   font-google-noto-sans-cjk
   font-google-noto-serif-cjk

   ;; media
   ;; blueman
   ffmpeg
   grimshot
   imagemagick
   imv
   mpv
   perl-image-exiftool
   yt-dlp

   ;; emacs
   emacs-pgtk
   emacs-aggressive-indent
   emacs-auctex
   emacs-bluetooth
   emacs-buffer-env
   emacs-consult
   emacs-corfu
   emacs-diredfl
   emacs-disable-mouse
   emacs-eat
   emacs-ef-themes
   emacs-elfeed
   emacs-geiser
   emacs-geiser-guile
   emacs-guix
   emacs-htmlize
   emacs-jack
   emacs-magit
   emacs-marginalia
   emacs-markdown-mode
   emacs-orderless
   emacs-org-bullets
   emacs-paredit
   emacs-pinentry
   emacs-tldr
   emacs-trashed
   emacs-vertico
   emacs-wgrep
   emacs-writeroom
   emacs-yaml-mode
   mrh-emacs-nerd-icons-dired
   mrh-emacs-nm
   mrh-emacs-org-publish-rss

   ;; programming
   git
   (list git "send-email")
   gnu-make
   tree-sitter-go

   ;; lisp
   guile-swayer
   guile-taglib

   ;; communication
   isync
   mu
   signal-desktop
   zoom

   ;; security
   gnupg
   keepassxc
   pinentry-tty

   ;; sysadmin
   (list isc-bind "utils")
   rsync
   socat
   stow

   ;; misc
   cups
   (list glib "bin")
   aspell
   aspell-dict-en
   monero
   pandoc
   rlwrap
   texlive-scheme-full
   unzip
   xdg-desktop-portal
   xdg-utils
   ))
