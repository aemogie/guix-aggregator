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
                     texlive
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
   emacs-disable-mouse
   emacs-doom-modeline
   emacs-elfeed
   emacs-geiser
   emacs-geiser-guile
   emacs-gruvbox-theme
   emacs-htmlize
   emacs-jack
   emacs-magit
   emacs-marginalia
   emacs-markdown-mode
   emacs-nerd-icons
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

   ;; programming
   git
   (list git "send-email")
   gnu-make
   hut

   ;; C
   ccls

   ;; lisp
   sbcl
   sbcl-alexandria
   sbcl-anaphora
   sbcl-arrow-macros
   sbcl-clack
   sbcl-ciel
   sbcl-ciel-repl
   sbcl-clingon
   sbcl-cl-csv
   sbcl-dexador
   sbcl-easy-routes
   sbcl-fset
   sbcl-jzon
   sbcl-local-time
   sbcl-plump
   sbcl-cl-ppcre
   sbcl-quri
   sbcl-serapeum
   sbcl-spinneret
   sbcl-cl-str
   sbcl-trivia
   mrh-cl-taglib
   mrh-sbcl-clog-no-tools
   mrh-sbcl-coleslaw
   mrh-lem

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
   texlive
   unzip
   ))
