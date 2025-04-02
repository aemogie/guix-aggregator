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

;; load SSS defaults
(load "../system/sss-defaults.scm")

;; load user preferences per-host
(load "../per-host.scm")

;; show input settings
(load "../system/show-settings.scm")
(sss-show-settings)

(load "../lib/path.scm")

;; Autoload all Scheme modules in lib and subdirectories
;; All modules should have the `.scm' extension
(load-lib-modules)

;; Load Guile modules
(use-modules (gnu home)
             (gnu services)
             (guix gexp)
             (gnu packages admin)
             (gnu home services)
             (gnu home services shells)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop))

;; Load SSS modules
(use-modules (sss process)
             (sss foot)
             (sss git)
             (sss vars)
             (sss mako)
             (sss channels)
             (sss fastfetch)
             (sss conky)
             (sss enchant)
             (sss nix)
             (sss fontconfig)
             (sss hyprland hyprlang)
             (sss hyprland hyprland)
             (sss hyprland hyprlock)
             (sss hyprland hyprpaper)
             (sss bash)
             (sss containers)
             (sss mime)
             (sss fish)
             (sss gtk)
             (sss nyxt)
             (sss portals)
             (sss alacritty)
             (sss qt)
             (sss openpgp)
             (sss waybar)
             (sss rofi)
             (sss ssh)
             (sss emacs)
             (sss qutebrowser))

(define sss-home-files-service
  (service home-files-service-type
           (append (sss-gtk3-svc #:palette sss-palette)
                   (sss-gtk4-svc #:palette sss-palette)
                   (sss-git-svc)
                   (sss-waybar-svc #:palette sss-palette
                                   #:with-memory #t
                                   #:hyprland-session #t)
                   (sss-rofi-svc #:palette sss-palette)
                   (sss-alacritty-svc #:palette sss-palette)
                   (sss-foot-svc #:palette sss-palette)
                   (sss-hyprland-svc #:palette sss-palette
                                     #:clone-dir sss-clone-dir
                                     #:keyboard-layout sss-keyboard-layout
                                     #:caps-to-ctrl sss-caps-to-ctrl
                                     #:monitors sss-hyprland-monitors
                                     #:extra-startups
                                     sss-hyprland-extra-startups
                                     #:with-blur #t
                                     #:with-shadow #t)
                   (sss-hyprlock-svc #:clone-dir sss-clone-dir)
                   (sss-hyprpaper-svc #:clone-dir sss-clone-dir
                                      #:palette sss-palette)
                   (sss-mime-svc)
                   (sss-nyxt-svc)
                   (sss-fastfetch-svc #:clone-dir sss-clone-dir)
                   (sss-fish-svc #:clone-dir sss-clone-dir
                                 #:palette sss-palette)
                   (sss-mako-svc #:palette sss-palette)
                   (sss-qutebrowser-svc #:palette sss-palette)
                   (sss-emacs-svc #:palette sss-palette
                                  #:user-name "Joe"
                                  #:user-full-name "Josep Bigorra"
                                  #:user-initials "JJBA"
                                  #:user-email "jjbigorra@gmail.com"
                                  #:clone-dir sss-clone-dir
                                  #:notes-roam-dir
                                  "$HOME/hacking/private-notes/Roam")
                   (sss-nix-svc)
                   (sss-qt6-svc #:palette sss-palette)
                   (sss-containers-svc)
                   (sss-conky-svc)
                   (sss-portals-svc)
                   (sss-enchant-svc))))

;; Configure user's Guix home environment
(display "
>>= configuring Joe's home environment...
")
(home-environment
  (services
   (append (list sss-home-files-service
                 (sss-ssh-service)
                 (sss-home-vars-service #:clone-dir sss-clone-dir
                                        #:lang sss-lang)
                 (sss-bash-service #:clone-dir sss-clone-dir)
                 sss-openpgp-conf
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 sss-fontconfig-service-type
                 sss-channels-service) %base-home-services)))

