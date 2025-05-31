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

;; Code:

(use-modules (gnu)
             (gnu bootloader)
             (gnu system file-systems)
             (gnu home)
             (gnu services)
             (guix gexp)
             (gnu packages admin)
             (gnu home services)
             (gnu home services shells)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop)
             (json)
             (sxml simple)
             (sss prelude)
             (sss prelude)
             (sss git)
             (sss vars)
             (sss mako)
             (sss enchant)
             (sss fontconfig)
             (sss bash)
             (sss gtk)
             (sss nix)
             (sss containers)
             (sss dirs)
             (sss wallpaper)
             (sss portals)
             (sss qt)
             (sss channels)
             (sss mime)
             (sss openpgp)
             (sss waybar)
             (sss rofi)
             (sss ssh)
             (sss labwc))

;; show active SSS per-host settings
(log-exprs (get-setting 'lang)
           (get-setting 'timezone)
           (get-setting 'keyboard-layout)
           (get-setting 'caps-to-ctrl?)
           (get-setting 'hostname)
           (get-setting 'clone-dir)
           (get-setting 'palette)
           (get-setting 'hyprland-monitors)
           (get-setting 'hyprland-extra-startups)
           (get-setting 'labwc-extra-startups)
           (get-setting 'flatpak-user-remotes)
           (length (get-setting 'flatpak-pkgs))
           (length (get-setting 'extra-packages))
           (length (get-setting 'nixpkgs)))

(define sss-home-files-service
  (service home-files-service-type
           (append (gtk3-capability #:palette (get-setting 'palette)
                                    #:sans-font (get-setting 'sans-font))
                   (gtk4-capability #:palette (get-setting 'palette)
                                    #:sans-font (get-setting 'sans-font))
                   (nix-capability)
                   (rofi-capability #:palette (get-setting 'palette)
                                    #:sans-font (get-setting 'sans-font))
                   (mime-capability)
                   (waybar-capability #:palette (get-setting 'palette)
                                      #:sans-font (get-setting 'sans-font)
                                      #:with-memory #f
                                      #:labwc-session #t
                                      #:sans-font (get-setting 'sans-font))
                   (portals-capability)
                   (mako-capability #:palette (get-setting 'palette)
                                    #:sans-font (get-setting 'sans-font))
                   (containers-capability)
                   (hyprlock-capability #:clone-dir (get-setting 'clone-dir))
                   (dirs-capability)
                   (random-wallpaper-capability #:clone-dir (get-setting 'clone-dir)
                                                #:palette (get-setting 'palette))
                   (labwc-capability #:extra-startups (get-setting 'labwc-extra-startups)))))

(display "
>>= configuring Manon's home environment...
")

(home-environment
  (services
   (append (list sss-home-files-service
                 (env-variables-capability #:palette (get-setting 'palette)
                                           #:clone-dir (get-setting 'clone-dir)
                                           #:lang (get-setting 'lang))
                 (bash-capability #:clone-dir (get-setting 'clone-dir)
                                  #:gui-cmd "labwc")
                 openpgp-capability
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 (fontconfig-capability #:mono-font (get-setting 'mono-font))
                 channels-capability) %base-home-services)))

