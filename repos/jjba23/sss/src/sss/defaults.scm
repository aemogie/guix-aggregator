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

(define-module (sss defaults)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (gnu packages)
  #:use-module (gnu bootloader)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system accounts)
  #:export (default-bootloader-configuration default-caps-to-ctrl?
                                             default-clone-dir
                                             default-extra-packages
                                             default-filesystems
                                             default-flatpak-pkgs
                                             default-flatpak-user-remotes
                                             default-hostname
                                             default-niri-extra-startups
                                             default-niri-monitors
                                             default-keyboard-layout
                                             default-labwc-extra-startups
                                             default-lang
                                             default-mapped-devices
                                             default-mono-font
                                             default-nixpkgs
                                             default-palette
                                             default-sans-font
                                             default-timezone
                                             default-subgids
                                             default-subuids
                                             default-sudoers
                                             default-users))

;; root privileges per user (sudo)
(define default-sudoers
  (let ((no-passwd-cmd (string-join '("/run/current-system/profile/sbin/halt"
                                      "/run/current-system/profile/bin/chvt"
                                      "/run/current-system/profile/sbin/reboot"
                                      "/run/current-system/profile/bin/loginctl")
                                    ",")))
    (string-join `("root ALL=(ALL) NOPASSWD:ALL" "%wheel ALL=(ALL) ALL"
                   ,(format #f "sss ALL=(ALL) NOPASSWD:~a" no-passwd-cmd))
                 "\n")))

;; subgids and subuids for containers (Podman)
(define default-subgids
  '())
(define default-subuids
  '())

;; user accounts
(define default-users
  (list (user-account
          (name "sss")
          (group "users")
          (supplementary-groups '("wheel" "netdev"
                                  "audio"
                                  "video"
                                  "input"
                                  "libvirt"
                                  "cgroup"))
          (comment "default sss account")
          (home-directory "/home/sss"))))

;; system language
(define default-lang
  "en_US")

;; system timezone
(define default-timezone
  "Europe/Amsterdam")

;; system keyboard layout
(define default-keyboard-layout
  "us")

;; caps to control enabled
(define default-caps-to-ctrl?
  #t)

;; system hostname
(define default-hostname
  "gnu-system")

;; mapped devices (encrypted file systems)
(define default-mapped-devices
  '())

;; file systems (partitions)
(define default-filesystems
  #f)

;; bootloader configuration
(define default-bootloader-configuration
  (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets '("/boot/efi"))))

;; location where you cloned SSS Git repository
(define default-clone-dir
  "$HOME/hacking/sss")

;; packages that should only be installed in the current host
(define default-extra-packages
  '())

;; color palette choices:
;;   - ef-bio
;;   - ef-cyprus
;;   - ef-dream
;;   - ef-autumn
;;   - ef-melissa-light
;;   - heavy-metal
;;   - solarized-light
;;   - everforest-dark
;;   - everforest-light
;;   - gruvbox-dark (WIP)
;;   - gruvbox-light (WIP)
(define default-palette
  'ef-dream)

;; Sans-serif font choice for the system
;;
;; some good choices:
;; - Liberation Sans
;; - Adwaita Sans
;; - IBM Plex Sans
;;
(define default-sans-font
  "IBM Plex Sans")

;; Serif font choice for the system
;;
;; some good choices:
;; - Liberation Serif
;; - Noto Serif
;; - IBM Plex Serif
;;
(define default-serif-font
  "IBM Plex Serif")

;; Monospaced font choice for the system
;;
;; some good choices:
;; - Liberation Mono
;; - Adwaita Mono
;; - IBM Plex Mono
(define default-mono-font
  "IBM Plex Mono")

;; Nix packages to install
(define default-nixpkgs
  '(_1password-cli _1password-gui
                   awscli
                   azure-cli
                   bash-language-server
                   black
                   bruno
                   bruno-cli
                   signal-desktop
                   signal-cli
                   cloudflare-warp
                   deadnix
                   discord
                   gh
                   natscli
                   ibm-plex
                   jdt-language-server
                   jetbrains.idea-community
                   krew
                   marksman
                   mermaid-cli
                   nil
                   nixfmt
                   nwg-look
                   onefetch
                   postman
                   prettierd
                   pyright
                   rustfmt
                   sbt
                   scala-cli
                   scala_2_13
                   spotify
                   stylelint
                   stylelint-lsp
                   typescript-language-server
                   vscode-langservers-extracted
                   way-displays
                   yaml-language-server))

;; Flatpak remotes to add to a user
(define default-flatpak-user-remotes
  '((flathub . "https://dl.flathub.org/repo/flathub.flatpakrepo")))

;; Flatpak packages to install to the user
(define default-flatpak-pkgs
  '(app.drey.Dialect app.drey.Warp
                     app.zen_browser.zen
                     com.anydesk.Anydesk
                     com.brave.Browser
                     com.belmoussaoui.Decoder
                     com.github.hugolabe.Wike
                     com.github.tchx84.Flatseal
                     com.ktechpit.whatsie
                     com.mardojai.ForgeSparks
                     com.rafaelmardojai.Blanket
                     com.usebottles.bottles
                     de.haeckerfelix.Fragments
                     dev.Cogitri.Health
                     dev.bragefuglseth.Fretboard
                     dev.geopjr.Collision
                     engineer.atlas.Nyxt
                     org.gnome.Fractal
                     io.bassi.Amberol
                     io.beekeeperstudio.Studio
                     io.github.fizzyizzy05.binary
                     io.github.idevecore.Valuta
                     io.github.revisto.drum-machine
                     io.github.seadve.Mousai
                     io.gitlab.adhami3310.Converter
                     org.prismlauncher.PrismLauncher
                     org.gaphor.Gaphor
                     org.gnome.design.Emblem
                     org.gnome.design.Lorem
                     se.sjoerd.Graphs))

;; Additional Niri startup commands on per-host basis
(define default-niri-extra-startups
  '())

;; Additional Labwc startup commands on per-host basis
(define default-labwc-extra-startups
  '())

;; Niri monitor configurations as a list of strings (lines)
;;
;; you can have a sensible default like "monitor = , preferred, auto, 1"
;; or more detailed config like "monitor=DP-1,1920x1080@144,0x0,1"
;; see https://wiki.niri.org/niri-wiki/pages/Configuring/Monitors/
;;
;; (define default-niri-monitors
;;   '("monitor = , preferred, auto, 1"))

;; Seconds after which we will decrease the screen brightness.
(define default-brightness-timeout-seconds
  480)

;; Seconds after which we will lock the screen.
(define default-lock-screen-seconds
  600)

;; Seconds after which we will power off the monitor.
(define default-monitor-power-seconds
  900)

