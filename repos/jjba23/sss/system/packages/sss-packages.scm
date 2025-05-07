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

(use-package-modules admin
                     android
                     aspell
                     astronomy
                     audio
                     autotools
                     base
                     bash
                     bittorrent
                     chromium
                     cinnamon
                     cmake
                     commencement
                     compression
                     containers
                     cpp
                     cups
                     curl
                     databases
                     disk
                     display-managers
                     emacs
                     emacs-xyz
                     enchant
                     engineering
                     file-systems
                     firmware
                     fonts
                     fontutils
                     freedesktop
                     games
                     gcc
                     gdb
                     gettext
                     gimp
                     gl
                     glib
                     gnome
                     gnome-xyz
                     gnupg
                     gnuzilla
                     golang
                     graphics
                     gsasl
                     gtk
                     guile
                     guile-xyz
                     haskell-apps
                     image
                     image
                     image-viewers
                     imagemagick
                     inkscape
                     kde
                     kde-frameworks
                     kde-plasma
                     kde-systemtools
                     kde-utils
                     kerberos
                     libreoffice
                     linux
                     lisp
                     lisp-xyz
                     llvm
                     lua
                     lxde
                     lxqt
                     mpd
                     multiprecision
                     music
                     ncurses
                     networking
                     node
                     nss
                     package-management
                     parallel
                     perl
                     pkg-config
                     polkit
                     pulseaudio
                     python
                     python-web
                     python-xyz
                     qt
                     rust-apps
                     screen
                     shells
                     shellutils
                     sqlite
                     ssh
                     terminals
                     texinfo
                     texlive
                     text-editors
                     tls
                     tree-sitter
                     version-control
                     video
                     vim
                     virtualization
                     vnc
                     vpn
                     web
                     web-browsers
                     wm
                     xdisorg
                     xfce
                     xorg)

(load "../../per-host.scm")

(define sss-font-packages
  (list font-adwaita
        font-awesome
        font-dejavu
        font-fira-code
        font-google-noto
        font-google-noto-emoji
        font-google-roboto
        font-liberation
        font-microsoft-web-core-fonts
        fontconfig))

(define sss-normie-packages
  (list labwc))

(define sss-wm-packages
  (list rofi-wayland
        fzf

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
  (list adwaita-icon-theme gnome-themes-standard numix-gtk-theme
        papirus-icon-theme yaru-theme))

(define sss-latex-packages
  (list texinfo texlive))

(define sss-music-packages
  (list spotifyd lilypond ardour))

(define sss-browser-packages
  (list (specification->package "firefox")
        (specification->package "google-chrome-beta")))

(define sss-qt-packages
  (list qtwayland qt6ct qtsvg))

(define* (sss-other-system-packages #:key architecture)
  (list android-file-transfer
        autoconf
        automake
        binutils
        blender
        blueman
        bluez
        bsd-games
        cheese
        cmatrix
        desktop-file-utils
        direnv
        drill
        emacs-pinentry
        evince
        exfat-utils
        exfatprogs
        fastfetch
        feh
        (specification->package "ffmpegthumbs")
        flameshot
        flatpak
        freecad
        fuse-exfat
        fyi
        fyi
        gdb
        geany
        (specification->package "gettext")
        ghcid
        gimp
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-clocks
        gnome-font-viewer
        gnome-system-monitor
        gparted
        gthumb
        gtk
        hplip
        httpie
        icedove
        imagemagick
        inkscape
        jq
        libreoffice
        light
        lm-sensors
        lxsession
        mpv
        mpv-mpris
        nemo
        netcat
        nginx
        obs
        ovmf-x86-64
        pamixer
        parallel
        pavucontrol
        perl
        pinentry
        pinentry-tty
        pipewire
        pkg-config
        power-profiles-daemon
        powertop
        qemu
        reaper
        remmina
        sqlitebrowser
        stellarium
        stress
        stress-ng
        sysstat
        tmon
        transmission
        transmission-remote-gtk
        tree
        tumbler
        unixodbc
        virt-manager
        watchexec
        xarchiver
        xdg-user-dirs
        xf86-input-libinput
        xf86-video-fbdev
        xxd
        xz
        youtube-dl))

(define sss-container-packages
  (list podman-compose passt))

(define sss-net-packages
  (list openvpn
        (specification->package "darkhttpd")
        network-manager-applet
        network-manager-openconnect
        wireshark
        network-manager-openvpn))

(define sss-dict-packages
  (list aspell
        aspell-dict-ca
        aspell-dict-en
        aspell-dict-es
        aspell-dict-nl
        aspell-dict-pt-pt
        enchant))

(define sss-shell-packages
  (list fish))

(define sss-emacs-packages
  (list emacs-jinx))

(define sss-hypr-packages
  (list grimblast hyprland hypridle hyprcursor hyprlock))

(define sss-libs-packages
  (list aria2
        libevdev
        libinput
        libltdl
        libtool
        libwebp
        libxkbcommon
        libxkbfile
        mit-krb5
        nss
        wmctrl
        xdotool
        zlib))

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
            sss-libs-packages
            sss-dict-packages
            sss-net-packages
            sss-theme-packages))
  (export sss-system-packages))
