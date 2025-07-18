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
             (sss dconf)
             (sss waybar)
             (sss rofi)
             (sss ssh)
             (sss labwc))

(setup-i18n)
(log-active-sss-settings)

(define sss-home-files-service
  (service home-files-service-type
           (append (gtk3-capability #:palette ($$$ 'palette)
                                    #:sans-font ($$$ 'sans-font))
                   (gtk4-capability #:palette ($$$ 'palette)
                                    #:sans-font ($$$ 'sans-font)
                                    #:mono-font ($$$ 'mono-font))
                   (nix-capability)
                   (rofi-capability #:palette ($$$ 'palette)
                                    #:sans-font ($$$ 'sans-font))
                   (mime-capability)
                   (waybar-capability #:palette ($$$ 'palette)
                                      #:sans-font ($$$ 'sans-font)
                                      #:with-memory #f
                                      #:labwc-session #t
                                      #:sans-font ($$$ 'sans-font))
                   (portals-capability)
                   (mako-capability #:palette ($$$ 'palette)
                                    #:sans-font ($$$ 'sans-font))
                   (containers-capability)
                   (hyprlock-capability #:clone-dir ($$$ 'clone-dir))
                   (dirs-capability)
                   (gtk-dconf-capability #:palette ($$$ 'palette)
                                         #:sans-font ($$$ 'sans-font)
                                         #:mono-font ($$$ 'mono-font))
                   (sss-dconf-capability #:lang ($$$ 'lang)
                                         #:timezone ($$$ 'timezone)
                                         #:keyboard-layout ($$$ 'keyboard-layout)
                                         #:caps-to-ctrl? ($$$ 'caps-to-ctrl?)
                                         #:hostname ($$$ 'hostname)
                                         #:clone-dir ($$$ 'clone-dir)
                                         #:palette ($$$ 'palette)
                                         #:sans-font ($$$ 'sans-font)
                                         #:serif-font ($$$ 'serif-font)
                                         #:mono-font ($$$ 'mono-font)
                                         #:brightness-timeout-seconds ($$$ 'brightness-timeout-seconds)
                                         #:lock-screen-seconds ($$$ 'lock-screen-seconds)
                                         #:monitor-power-seconds ($$$ 'monitor-power-seconds))
                   (random-wallpaper-capability #:clone-dir ($$$ 'clone-dir)
                                                #:palette ($$$ 'palette))
                   (labwc-capability #:sans-font ($$$ 'sans-font)
                                     #:extra-startups ($$$ 'labwc-extra-startups)))))

(log-info (G_ "Configuring home environment for user: ~a") "manon")

(home-environment
  (services
   (append (list sss-home-files-service
                 (env-variables-capability #:palette ($$$ 'palette)
                                           #:clone-dir ($$$ 'clone-dir)
                                           #:lang ($$$ 'lang))
                 (bash-capability #:clone-dir ($$$ 'clone-dir)
                                  #:gui-cmd "labwc")
                 openpgp-capability
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 (fontconfig-capability #:mono-font ($$$ 'mono-font))
                 channels-capability) %base-home-services)))

