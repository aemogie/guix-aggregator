;;; SSS - Supreme Sexp System

;; Copyright (C) 2025 - Josep Bigorra, jjba23 <jjbigorra@gmail.com>

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

;; Code:

(use-modules (gnu)
             (gnu bootloader)
             (gnu system file-systems))

;;;
;;; SSS defaults section
;;;

;; set default values for optional `per-host.scm' values
;; which can be overriden on a host-per-host basis

;; system language
(define sss-lang
  "en_US")

;; system timezone
(define sss-timezone
  "Europe/Amsterdam")

;; system keyboard layout
(define sss-keyboard-layout
  "us")

;; caps to control enabled
(define sss-caps-to-ctrl
  #t)

;; system hostname
(define sss-hostname
  "gnusystem")

;; mapped devices (file systems)
(define sss-mapped-devices
  '())

;; bootloader configuration
(define sss-bootloader-configuration
  (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets '("/boot/efi"))))

;; location where you cloned SSS Git repository
(define sss-clone-dir
  "$HOME/hacking/sss")

;; packages that should only be installed in the current host
(define sss-per-host-packages
  '())

;; color palette (overridden by per-host)
;;   - sss-palette-ef-bio
;;   - sss-palette-ef-cyprus
;;   - sss-palette-ef-dream
;;   - sss-palette-heavy-metal
;;   - sss-palette-solarized-light
;;   - sss-palette-ef-autumn
(define sss-palette
  'sss-palette-ef-dream)

;; Nix packages to install
(define sss-nixpkgs
  '("yaml-language-server" "bash-language-server"
    "discord"
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
    "lua"
    "lua52Packages.lua-lsp"
    "awscli"))

;; Flatpak remotes to add to a user
(define sss-flatpak-user-remotes
  '((flathub . "https://dl.flathub.org/repo/flathub.flatpakrepo")))

;; Flatpak packages to install to the user
(define sss-flatpak-pkgs
  '("app.drey.Warp" "com.usebottles.bottles" "com.ktechpit.whatsie"
    "com.anydesk.Anydesk" "app.zen_browser.zen"))

;; Additional Hyprland startup commands on per-host basis
(define sss-hyprland-extra-startups
  '())

;; Additional Labwc startup commands on per-host basis
(define sss-labwc-extra-startups
  '())

;; Hyprland monitor configurations as a list of strings (lines)
;;
;; you can have a sensible default like "monitor = , preferred, auto, 1"
;; or more detailed config like "monitor=DP-1,1920x1080@144,0x0,1"
;; see https://wiki.hyprland.org/hyprland-wiki/pages/Configuring/Monitors/
;;
(define sss-hyprland-monitors
  '("monitor = , preferred, auto, 1"))

;;;
;;; end SSS defaults section
;;;

