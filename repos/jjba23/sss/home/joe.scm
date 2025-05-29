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
             (gnu home services mcron)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop)
             (shepherd service timer)
             (sss prelude)
             (sss prelude)
             (sss git)
             (sss vars)
             (sss mako)
             (sss channels)
             (sss fastfetch)
             (sss enchant)
             (sss nix)
             (sss fontconfig)
             (sss hyprland hyprlang)
             (sss hyprland hyprland)
             (sss hyprland hyprlock)
             (sss wallpaper)
             (sss bash)
             (sss containers)
             (sss mime)
             (sss fish)
             (sss gtk)
             (sss portals)
             (sss alacritty)
             (sss qt)
             (sss openpgp)
             (sss dirs)
             (sss waybar)
             (sss rofi)
             (sss labwc)
             (sss ssh)
             (sss firefox)
             (sss emacs))

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
           (append (gtk3-capability #:palette (get-setting 'palette))
                   (gtk4-capability #:palette (get-setting 'palette))
                   (git-capability)
                   (waybar-capability #:palette (get-setting 'palette)
                                      #:sans-font (get-setting 'sans-font)
                                      #:with-memory #t
                                      #:hyprland-session #t)
                   (rofi-capability #:palette (get-setting 'palette))
                   (alacritty-capability #:palette (get-setting 'palette)
                                         #:mono-font (get-setting 'mono-font))
                   (hyprland-capability #:palette (get-setting 'palette)
                                        #:clone-dir (get-setting 'clone-dir)
                                        #:keyboard-layout (get-setting 'keyboard-layout)
                                        #:caps-to-ctrl (get-setting 'caps-to-ctrl?)
                                        #:monitors (get-setting 'hyprland-monitors)
                                        #:extra-startups (get-setting 'hyprland-extra-startups)
                                        #:with-blur #t
                                        #:with-shadow #t)
                   (hyprlock-capability #:clone-dir (get-setting 'clone-dir))
                   (random-wallpaper-capability #:clone-dir (get-setting 'clone-dir)
                                                #:palette (get-setting 'palette))
                   (mime-capability)
                   (dirs-capability)
                   (firefox-capability #:palette (get-setting 'palette))
                   (fastfetch-capability #:clone-dir (get-setting 'clone-dir))
                   (fish-capability #:clone-dir (get-setting 'clone-dir)
                                    #:palette (get-setting 'palette))
                   (mako-capability #:palette (get-setting 'palette)
                                    #:sans-font (get-setting 'sans-font))
                   (emacs-capability #:palette (get-setting 'palette)
                                     #:user-name "Joe"
                                     #:user-full-name "Josep Bigorra"
                                     #:user-initials "JJBA"
                                     #:user-email "jjbigorra@gmail.com"
                                     #:clone-dir (get-setting 'clone-dir)
                                     #:notes-roam-dir
                                     "$HOME/hacking/private-notes/roam"
                                     #:sans-font (get-setting 'sans-font)
                                     #:mono-font (get-setting 'mono-font))
                   (nix-capability)
                   (qt6-capability #:palette (get-setting 'palette))
                   (containers-capability)
                   (portals-capability)
                   (enchant-capability)
                   (labwc-capability #:extra-startups (get-setting 'labwc-extra-startups)))))

(display "
>>= configuring Joe's home environment...
")

(home-environment
  (services
   (append (list sss-home-files-service
                 (ssh-capability)
                 (env-variables-capability #:palette (get-setting 'palette)
                                           #:clone-dir (get-setting 'clone-dir)
                                           #:lang (get-setting 'lang))
                 (bash-capability #:clone-dir (get-setting 'clone-dir)
                                  #:gui-cmd "hyprland")
                 openpgp-capability
                 (simple-service 'sss-home-cron-service
                                 home-mcron-service-type
                                 '())
                 (simple-service 'set-random-wallpaper
                                 home-shepherd-service-type
                                 (list (shepherd-timer '(set-random-wallpaper)
                                                       #~(cron-string->calendar-event
                                                          "*/10 * * * *")
                                                       `("sh" ,(format #f
                                                                "/home/joe/.local/bin/set-random-wallpaper.sh")))))
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 fontconfig-capability
                 channels-capability) %base-home-services)))

