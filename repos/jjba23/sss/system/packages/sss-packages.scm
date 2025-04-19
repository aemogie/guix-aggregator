;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

(define-module (sss packages)
  #:use-module (gnu)
  #:use-module (nongnu packages fonts)
  #:use-module (nongnu packages messaging)
  #:use-module (nongnu packages chrome)
  #:use-module (nongnu packages music)
  #:use-module (gnu services nix)
  #:use-module (sss packages conky)
  #:use-module (sss packages fonts)
  #:use-module (guix git-download)
  #:use-module (guix build-system font)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system guile)
  #:use-module (guix build-system qt)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build-system go)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system meson)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses)
                #:prefix license:))

(use-package-modules freedesktop
                     base
                     lxqt
                     package-management
                     parallel
                     web
                     gl
                     texinfo
                     cmake
                     vnc
                     autotools
                     perl
                     linux
                     golang
                     gnuzilla
                     ncurses
                     mpd
                     android
                     xfce
                     cpp
                     python-xyz
                     commencement
                     gnupg
                     llvm
                     image
                     multiprecision
                     kde
                     gcc
                     firmware
                     graphics
                     aspell
                     gdb
                     rust-apps
                     inkscape
                     texlive
                     gimp
                     python-web
                     python
                     xdisorg
                     tls
                     imagemagick
                     curl
                     cups
                     terminals
                     shells
                     video
                     image
                     compression
                     sqlite
                     disk
                     glib
                     networking
                     fontutils
                     lisp
                     image-viewers
                     gnome-xyz
                     guile-xyz
                     guile
                     bash
                     nss
                     pkg-config
                     games
                     qt
                     virtualization
                     polkit
                     gtk
                     kde-plasma
                     kde-frameworks
                     kde-utils
                     wm
                     compton
                     ssh
                     vpn
                     version-control
                     fonts
                     pulseaudio
                     libreoffice
                     lisp-xyz
                     web-browsers
                     audio
                     kde-systemtools
                     kde-multimedia
                     music
                     display-managers
                     file-systems
                     tree-sitter
                     lua
                     xorg
                     admin
                     screen
                     node
                     emacs
                     lxde
                     vim
                     astronomy
                     text-editors
                     enchant
                     emacs-xyz
                     containers
                     haskell-apps
                     gnome
                     databases
                     bittorrent
                     shellutils)

(load "../../per-host.scm")

(define (sss/x86-only-pkg architecture pkg)
  (if (string-prefix? "x86_64" architecture)
      (specification->package pkg)
      (specification->package "curl")))

(define sss-font-packages
  (list fontconfig
        font-google-roboto
        font-google-noto-emoji
        font-recursive
        font-microsoft-cascadia
        font-victor-mono
        font-jetbrains-mono
        font-intel-one-mono
        font-adwaita
        font-inter
        font-liberation
        font-dejavu
        font-microsoft-web-core-fonts
        font-awesome
        font-fira-code
        font-monaspace
        font-google-noto))

(define sss-normie-packages
  (list labwc))

(define sss-wm-packages
  (list rofi-wayland
        fzf
        sss-conky

        slurp

        waybar-experimental
        wmenu
        hyprpaper

        mako
        wev
        grimshot
        wl-color-picker
        qpwgraph
        wireplumber
        pipewire

        wl-clipboard

        ;; Wayland portals
        xdg-desktop-portal
        ;; xdg-desktop-portal-wlr
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk

        ;; Compatibility for older Xorg applications
        xorg-server-xwayland

        polkit-gnome

        ;; Flatpak and XDG utilities
        flatpak-xdg-utils
        xdg-utils
        xdg-dbus-proxy
        shared-mime-info
        (list glib "bin")))

(define sss-treesitter-packages
  (list tree-sitter
        tree-sitter-bash
        tree-sitter-dockerfile
        tree-sitter-lua
        tree-sitter-haskell
        tree-sitter-css
        tree-sitter-html
        tree-sitter-nix
        tree-sitter-scala
        tree-sitter-markdown
        tree-sitter-typescript
        tree-sitter-scheme
        tree-sitter-java
        tree-sitter-javascript))

(define sss-terminal-emulator-packages
  (list foot alacritty xfce4-terminal))

(define sss-dev-packages
  (list (specification->package "openjdk@21")
        (specification->package "node@22")
        (specification->package "python@3.10") cl-asdf sbcl))

(define sss-coreutils
  (list htop
        btop
        emacs-next-pgtk
        vim
        git
        openssh
        openssl
        clang
        dbus
        ncurses
        screen
        tar
        zip
        unzip
        gmp
        gcc
        gcc-toolchain
        curl
        ripgrep
        net-tools
        dstat
        dconf-editor
        (specification->package "make")
        nix
        coreutils
        seatd
        libseat
        elogind
        pango
        cairo
        xorg-server))

(define sss-theme-packages
  (list papirus-icon-theme
        yaru-theme
        numix-gtk-theme
        delft-icon-theme
        gnome-themes-standard
        gnome-themes-extra
        adwaita-icon-theme))

(define sss-latex-packages
  (list texinfo texlive))

(define sss-music-packages
  (list spotifyd lilypond ardour))

(define sss-browser-packages
  (list icecat icedove))

(define sss-qt-packages
  (list qtwayland qt6ct qtsvg))

(define* (sss-other-system-packages #:key architecture)
  (list flatpak
        pipewire
        nginx
        watchexec
        remmina
        pavucontrol

        geany

        tumbler

        gnome-font-viewer
        gnome-characters
        gnome-clocks

        xz

        gtk

        qutebrowser

        binutils

        gnome-calculator
        cheese
        gnome-system-monitor
        evince

        qemu
        inkscape
        obs
        libreoffice
        gimp
        libwebp
        feh

        gparted

        imagemagick

        lm-sensors
        exfatprogs
        exfat-utils
        fuse-exfat
        tmon
        flameshot

        parallel

        thunar

        pinentry
        pinentry-tty
        emacs-pinentry

        powertop
        ffmpegthumbs
        xarchiver

        blender

        gnome-calendar

        sqlitebrowser
        direnv
        netcat
        jq

        bsd-games

        power-profiles-daemon

        gthumb

        light

        gdb

        transmission
        transmission-remote-gtk

        xf86-video-fbdev
        xf86-input-libinput
        lxsession
        pamixer

        (sss/x86-only-pkg architecture "ghcid")
        httpie
        fastfetch
        cmatrix

        pkg-config
        fyi
        bluez
        blueman
        hplip
        desktop-file-utils

        libltdl
        libtool
        zlib
        ovmf-x86-64

        (sss/x86-only-pkg architecture "nyxt")

        autoconf
        automake

        libtool

        perl

        youtube-dl
        mpv
        mpv-mpris
        unixodbc
        tree
        fyi

        drill
        android-file-transfer

        (specification->package "gettext")

        (sss/x86-only-pkg architecture "google-chrome-stable")
        (sss/x86-only-pkg architecture "reaper")
        (sss/x86-only-pkg architecture "stellarium")
        (sss/x86-only-pkg architecture "virt-manager")

        nautilus

        xxd))

(define sss-container-packages
  (list podman-compose podman passt slirp4netns))

(define sss-net-packages
  (list openvpn
        (specification->package "darkhttpd")
        network-manager-applet
        network-manager-openconnect
        wireshark
        network-manager-openvpn))

(define sss-dict-packages
  (list enchant
        aspell
        aspell-dict-nl
        aspell-dict-pt-pt
        aspell-dict-es
        aspell-dict-en
        aspell-dict-ca))

(define sss-shell-packages
  (list fish))

(define sss-emacs-packages
  (list emacs-jinx))

(define-public hyprlock
  (package
    (name "hyprlock")
    (version "0.7.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hyprwm/hyprlock")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03ivr5nsjwiwvpdxpjnldwawy8sx8qgwhs57242xkb0zz0w0gvsk"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:cmake cmake-3.30)) ;No tests.
    (native-inputs (list gcc-14 pkg-config))
    (inputs (list hyprlang
                  hyprutils
                  hyprgraphics
                  sdbus-c++
                  wayland
                  wayland-protocols
                  mesa
                  libwebp
                  (specification->package "libjpeg")
                  libxkbcommon
                  hyprwayland-scanner
                  egl-wayland
                  cairo
                  linux-pam
                  pango))
    (home-page "https://github.com/hyprwm/hyprlock")
    (synopsis "Hyprland's lock screen")
    (description
     "Hyprland's simple, yet multi-threaded and GPU-accelerated screen locking utility.")
    (license license:bsd-3)))

(define sss-hypr-packages
  (list hyprland hypridle grimblast hyprcursor hyprlock))

;; SYSTEM PACKAGES
;;
;; Add packages here to install them system wide
(begin
  (define* (sss-system-packages #:key (per-host-packages '())
                                (architecture (or (%current-target-system)
                                                  (%current-system))))
    (append (map (lambda (x)
                   (specification->package x)) per-host-packages)
            (sss-other-system-packages #:architecture architecture)
            sss-wm-packages
            sss-normie-packages
            sss-font-packages
            sss-dev-packages
            sss-container-packages
            sss-treesitter-packages
            sss-coreutils
            sss-hypr-packages
            sss-terminal-emulator-packages
            sss-browser-packages
            sss-latex-packages
            sss-shell-packages
            sss-dict-packages
            sss-net-packages
            sss-theme-packages))
  (export sss-system-packages))
