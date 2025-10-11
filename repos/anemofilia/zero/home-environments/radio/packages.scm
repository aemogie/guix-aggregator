(define-module (home-environments radio packages)
  #|GNU packages|#
  #|A|# #:use-module (gnu packages admin)
  #|B|# #:use-module (gnu packages base)
        #:use-module (gnu packages bittorrent)
  #|C|# #:use-module (gnu packages c)
        #:use-module (gnu packages calendar)
        #:use-module (gnu packages commencement)
        #:use-module (gnu packages curl)
  #|D|# #:use-module (gnu packages databases)
        #:use-module (gnu packages dictionaries)
  #|E|# #:use-module (gnu packages emacs)
        #:use-module (gnu packages emacs-xyz)
  #|F|# #:use-module (gnu packages file)
        #:use-module (gnu packages freedesktop)
  #|G|# #:use-module (gnu packages games)
        #:use-module (gnu packages glib)
        #:use-module (gnu packages gnu-doc)
        #:use-module (gnu packages gnupg)
        #:use-module (gnu packages gtk)
        #:use-module (gnu packages guile)
        #:use-module (gnu packages guile-xyz)
  #|H|# #:use-module (gnu packages haskell)
        #:use-module (gnu packages haskell-apps)
        #:use-module (gnu packages haskell-xyz)
  #|I|# #:use-module (gnu packages image)
        #:use-module (gnu packages image-viewers)
        #:use-module (gnu packages imagemagick)
        #:use-module (gnu packages irc)
  #|L|# #:use-module (gnu packages lean)
        #:use-module (gnu packages libcanberra)
        #:use-module (gnu packages linux)
  #|M|# #:use-module (gnu packages mail)
        #:use-module (gnu packages maths)
        #:use-module (gnu packages messaging)
        #:use-module (gnu packages minetest)
  #|N|# #:use-module (gnu packages ncurses)
  #|O|# #:use-module (gnu packages ocr)
  #|P|# #:use-module (gnu packages password-utils)
        #:use-module (gnu packages pdf)
  #|R|# #:use-module (gnu packages rust-apps)
  #|S|# #:use-module (gnu packages scheme)
        #:use-module (gnu packages shells)
        #:use-module (gnu packages ssh)
        #:use-module (gnu packages syndication)
  #|T|# #:use-module (gnu packages terminals)
        #:use-module (gnu packages tex)
        #:use-module (gnu packages text-editors)
        #:use-module (gnu packages tree-sitter)
        #:use-module (gnu packages tmux)
        #:use-module (gnu packages toys)
  #|V|# #:use-module (gnu packages version-control)
        #:use-module (gnu packages video)
  #|W|# #:use-module (gnu packages web)
        #:use-module (gnu packages wm)
  #|X|# #:use-module (gnu packages xdisorg)

  #|home-environments radio|#
  #|C|# #:use-module ((home-environments radio channels)
                      #:prefix channel:)

  #|Radix packages|#
  #|D|# #:use-module (radix packages disk)
  #|E|# #:use-module (radix packages emacs-xyz)
  #|F|# #:use-module (radix packages fish-xyz)
        #:use-module (radix packages freedesktop)
  #|G|# #:use-module (radix packages games)
  #|K|# #:use-module (radix packages kak-xyz)
  #|M|# #:use-module (radix packages music)
  #|P|# #:use-module (radix packages pdf)
        #:use-module (radix packages pulseaudio)
  #|S|# #:use-module (radix packages seninha)
  #|T|# #:use-module (radix packages text-editors)
        #:use-module (radix packages toys)
  #|V|# #:use-module (radix packages video)
  #|W|# #:use-module (radix packages wm)
  #|X|# #:use-module (radix packages xdisorg)

  #|Saayix packages|#
  #|B|# #:use-module (saayix packages binaries)
  #|W|# #:use-module (saayix packages wm)

  #:export (blogging
            desktop
            development
            documentation
            downloads
            emacs
            file-managing
            games
            haskell
            image
            mathematics
            messaging
            music
            password
            reading
            scheme
            sound
            tex
            typst
            video
            web))

(define blogging
  (list #|guile-xyz|# haunt))

(define desktop
  (list #|admin      |# fastfetch
        #|calendar   |# remind
        #|freedesktop|# xdg-utils xdg-desktop-portal xdg-desktop-portal-wlr
                        xdg-desktop-portal-termfilechooser xdg-terminal-exec
        #|glib       |# dbus
        #|image      |# grim slurp
        #|libcanberra|# sound-theme-freedesktop
        #|ncurses    |# ncurses
        #|terminals  |# foot
        #|toys       |# wayneko
        #|video      |# wf-recorder
        #|wm         |# eww/wayland fnott lswt river-bedload rivercarro wbg
        #|web        |# jq
        #|xdisorg    |# fuzzel-lowercase gammastep wl-clipboard wlrctl
        #|zig-xyz    |# river))

(define development
  (list #|admin         |# tree
        #|base          |# patch
        #|databases     |# recutils
        #|gnupg         |# gnupg pinentry
        #|math          |# libqalculate
        #|ssh           |# openssh
        #|text-editors  |# kakoune kak-lsp
        #|kak-xyz       |# kak-auto-pairs kak-board kak-buffers
                           kak-phantom-selection kak-rainbower kak-state-save
                           kak-snippets kak-surround kak-tree-sitter
        #|tmux          |# tmux
        #|vesion-control|# diff-so-fancy git))

(define documentation
  (list #|c      |# c-intro-and-ref
        #|gnu-doc|# gnu-standards
        #|scheme |# r7rs-small-texinfo sicp))

(define downloads
  (list #|bittorrent|# aria2 qbittorrent
        #|curl      |# curl
        #|video     |# yt-dlp))

(define file-managing
  (list #|disk         |# lf
        #|file         |# file
        #|haskell-xyz  |# pandoc
        #|image-viewers|# chafa
        #|pdf          |# img2pdf poppler
        #|seninha      |# fmutils
        #|video        |# ffmpegthumbnailer))

(define games
  (list #|games|# minetest red-eclipse srb2 supertuxkart xonotic))

(define haskell
  (list #|commencement|# gcc-toolchain
        #|haskell     |# ghc
        #|haskell-xyz |# ghc-async ghc-base-prelude ghc-basement
                         ghc-basic-prelude ghc-chart ghc-groups
        #|haskell-apps|# hoogle))

(define image
  (list #|image-viewers|# imv
        #|ocr          |# tesseract-ocr))

(define messaging
  (list #|mail     |# aerc
        #|messaging|# senpai))

(define music
  (list #|music|# kew))

(define password
  (list #|password-utils|# password-store tessen))

(define reading
  (list #|dictionaries|# translate-shell
        #|pdf         |# sioyek-kebab
        #|syndication |# newsraft))

(define scheme
  (list #|guile    |# guile-next guile-colorized guile-readline
        #|guile-xyz|# guile-goblins guile-hoot guile-lib guile-lsp-server
                      guile-srfi-197 guile-srfi-232))

(define mathematics
  (list #|lean|# lean4))

(define sound
  (list #|linux     |# wireplumber-minimal
        #|pulseaudio|# ncpamixer
        #|rust-apps |# helvum))

(define tex
  (list #|tex|# rubber
                texlive-collection-fontsextra
                texlive-collection-fontsrecommended
                texlive-collection-latexextra
                texlive-collection-luatex
                texlive-collection-langportuguese
                texlive-collection-langenglish
                texlive-collection-langfrench
                texlive-collection-mathscience))

(define typst
  (list #|rust-apps|# (@ (gnu packages rust-apps) typst) typstyle
        #|tree-sitter|# tree-sitter-typst))

(define video
  (list #|video|# ani-cli ffmpeg mpv-minimal/wayland))

(define web
  (list #|binaries|# zen-browser-bin
        #|gtk     |# gtk+)) ;needed for zen not crash when using termfilechooser

(define emacs:base
  (list emacs-next-pgtk
        emacs-bug-hunter
        emacs-benchmark-init emacs-gcmh emacs-general emacs-helpful emacs-no-littering
        emacs-on))

(define emacs:buffer-management
  (list emacs-activities
        emacs-ace-window
        emacs-perspective
        emacs-perspective-tabs))

(define emacs:modeline
  (list emacs-diminish))

(define emacs:completion
  (list emacs-anzu emacs-cape emacs-corfu emacs-corfu-doc emacs-consult
        emacs-consult-lsp emacs-embark emacs-marginalia emacs-orderless
        emacs-vertico))

(define emacs:file-managing
  (list emacs-all-the-icons emacs-dired-git-info emacs-dired-hacks
        emacs-dired-hide-dotfiles emacs-dired-preview imagemagick))

(define emacs:ide
  (list emacs-magit emacs-hl-fill-column emacs-origami))

(define emacs:guile
  (list emacs-arei guile-ares-rs emacs-macrostep-geiser emacs-geiser-eros
        emacs-flycheck emacs-flycheck-guile emacs-lispy emacs-rainbow-delimiters
        emacs-isayt emacs-puni))

(define emacs:guix
  (cons emacs-guix emacs:guile))

(define emacs:haskell
  (list emacs-haskell-mode emacs-dante))

(define emacs:themes
  (list emacs-ef-themes))

;; https://github.com/oantolin/embark ?
(define emacs:modal-editing
  (list emacs-meow
        emacs-zones emacs-expand-region emacs-ryo-modal emacs-visual-regexp
        emacs-undo-tree
        emacs-selected emacs-crux))

(define emacs:misc
  (list emacs-osm emacs-pulsar))

(define emacs:communication
  (list emacs-circe emacs-notmuch))

(define emacs:mathematics
  (list emacs-lean4-mode))

(define emacs:org
  (list emacs-org-appear emacs-org-auto-tangle emacs-org-fragtog emacs-org-present
        emacs-org-roam emacs-org-modern emacs-olivetti emacs-toc-org)) ;emacs-org-pdftools

(define emacs:studying
  (list emacs-gnosis
        emacs-hyperbole
        emacs-pdf-tools
        emacs-saveplace-pdf-view))

(define emacs:social-media
  (list emacs-mastodon))

(define emacs:terminal
  (list emacs-eat))

(define emacs:writing
  (list emacs-auctex emacs-latex-preview-pane))

(define emacs:blogging
  (cons* emacs-ox-haunt
         emacs:writing))

(define emacs
  (append emacs:base
          emacs:blogging
          emacs:buffer-management
          emacs:completion
          emacs:communication
          emacs:file-managing
          emacs:guile
          emacs:guix
          emacs:haskell
          emacs:ide
          emacs:mathematics
          emacs:misc
          emacs:modal-editing
          emacs:modeline
          emacs:org
          emacs:studying
          emacs:social-media
          emacs:terminal
          emacs:themes
          emacs:writing))
