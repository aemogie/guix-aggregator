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
  #:export (sss-default-bootloader-configuration sss-default-caps-to-ctrl?
            sss-default-clone-dir
            sss-default-extra-packages
            sss-default-filesystems
            sss-default-flatpak-pkgs
            sss-default-flatpak-user-remotes
            sss-default-hostname
            sss-default-hyprland-extra-startups
            sss-default-hyprland-monitors
            sss-default-keyboard-layout
            sss-default-labwc-extra-startups
            sss-default-lang
            sss-default-mapped-devices
            sss-default-mono-font
            sss-default-nixpkgs
            sss-default-palette
            sss-default-sans-font
            sss-default-timezone
            sss-default-subgids
            sss-default-subuids
            sss-default-sudoers
            sss-default-users))

;; root privileges per user (sudo)
(define sss-default-sudoers
  (let ((no-passwd-cmd (string-join '("/run/current-system/profile/sbin/halt"
                                      "/run/current-system/profile/bin/chvt"
                                      "/run/current-system/profile/sbin/reboot"
                                      "/run/current-system/profile/bin/loginctl")
                                    ",")))
    (string-join `("root ALL=(ALL) NOPASSWD:ALL" "%wheel ALL=(ALL) ALL"
                   ,(format #f "sss ALL=(ALL) NOPASSWD:~a" no-passwd-cmd))
                 "\n")))

;; subgids and subuids for containers (Podman)
(define sss-default-subgids
  '())
(define sss-default-subuids
  '())

;; user accounts
(define sss-default-users
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
(define sss-default-lang
  "en_US")

;; system timezone
(define sss-default-timezone
  "Europe/Amsterdam")

;; system keyboard layout
(define sss-default-keyboard-layout
  "us")

;; caps to control enabled
(define sss-default-caps-to-ctrl?
  #t)

;; system hostname
(define sss-default-hostname
  "gnu-system")

;; mapped devices (encrypted file systems)
(define sss-default-mapped-devices
  '())

;; file systems (partitions)
(define sss-default-filesystems
  #f)

;; bootloader configuration
(define sss-default-bootloader-configuration
  (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets '("/boot/efi"))))

;; location where you cloned SSS Git repository
(define sss-default-clone-dir
  "$HOME/hacking/sss")

;; packages that should only be installed in the current host
(define sss-default-extra-packages
  '())

;; color palette
;;   - sss-palette-ef-bio
;;   - sss-palette-ef-cyprus
;;   - sss-palette-ef-dream
;;   - sss-palette-heavy-metal
;;   - sss-palette-solarized-light
;;   - sss-palette-ef-autumn
;;   - sss-palette-everforest-dark
;;   - sss-palette-everforest-light
(define sss-default-palette
  'sss-palette-ef-dream)

(define sss-default-sans-font
  "Adwaita Sans")

(define sss-default-mono-font
  "Adwaita Mono")

;; Nix packages to install
(define sss-default-nixpkgs
  '("yaml-language-server" "bash-language-server"
    "discord"
    "typescript-language-server"
    "spotify"
    "jdt-language-server"
    "nil"
    "black"
    "pyright"
    "marksman"
    "_1password-gui"
    "_1password-cli"
    "stack"
    "sbt"
    "scala_2_13"
    "scala-cli"
    "onefetch"
    "postman"
    "vscode-langservers-extracted"
    "nwg-look"
    "krew"
    "cloudflare-warp"
    "mermaid-cli"
    "jetbrains.idea-community"
    "nixfmt"
    "dbeaver-bin"
    "rustfmt"
    "way-displays"
    "deadnix"
    "awscli"))

;; Flatpak remotes to add to a user
(define sss-default-flatpak-user-remotes
  '((flathub . "https://dl.flathub.org/repo/flathub.flatpakrepo")))

;; Flatpak packages to install to the user
(define sss-default-flatpak-pkgs
  '("app.drey.Warp" "com.usebottles.bottles" "com.ktechpit.whatsie"
    "com.anydesk.Anydesk" "app.zen_browser.zen"))

;; Additional Hyprland startup commands on per-host basis
(define sss-default-hyprland-extra-startups
  '())

;; Additional Labwc startup commands on per-host basis
(define sss-default-labwc-extra-startups
  '())

;; Hyprland monitor configurations as a list of strings (lines)
;;
;; you can have a sensible default like "monitor = , preferred, auto, 1"
;; or more detailed config like "monitor=DP-1,1920x1080@144,0x0,1"
;; see https://wiki.hyprland.org/hyprland-wiki/pages/Configuring/Monitors/
;;
(define sss-default-hyprland-monitors
  '("monitor = , preferred, auto, 1"))

