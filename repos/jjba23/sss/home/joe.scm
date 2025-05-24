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
             (sss process)
             (sss foot)
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
           (append (sss-gtk3-svc #:palette (get-setting 'palette))
                   (sss-gtk4-svc #:palette (get-setting 'palette))
                   (sss-git-svc)
                   (sss-waybar-svc #:palette (get-setting 'palette)
                                   #:sans-font (get-setting 'sans-font)
                                   #:with-memory #t
                                   #:hyprland-session #t)
                   (sss-rofi-svc #:palette (get-setting 'palette))
                   (sss-alacritty-svc #:palette (get-setting 'palette)
                                      #:mono-font (get-setting 'mono-font))
                   (sss-foot-svc #:palette (get-setting 'palette))
                   (sss-hyprland-svc #:palette (get-setting 'palette)
                                     #:clone-dir (get-setting 'clone-dir)
                                     #:keyboard-layout (get-setting 'keyboard-layout)
                                     #:caps-to-ctrl (get-setting 'caps-to-ctrl?)
                                     #:monitors (get-setting 'hyprland-monitors)
                                     #:extra-startups (get-setting 'hyprland-extra-startups)
                                     #:with-blur #t
                                     #:with-shadow #t)
                   (sss-hyprlock-svc #:clone-dir (get-setting 'clone-dir))
                   (sss-wallpaper-svc #:clone-dir (get-setting 'clone-dir)
                                      #:palette (get-setting 'palette))
                   (sss-mime-svc)
                   (sss-dirs-svc)
                   (sss-firefox-svc #:palette (get-setting 'palette))
                   (sss-fastfetch-svc #:clone-dir (get-setting 'clone-dir))
                   (sss-fish-svc #:clone-dir (get-setting 'clone-dir)
                                 #:palette (get-setting 'palette))
                   (sss-mako-svc #:palette (get-setting 'palette)
                                 #:sans-font (get-setting 'sans-font))
                   (sss-emacs-svc #:palette (get-setting 'palette)
                                  #:user-name "Joe"
                                  #:user-full-name "Josep Bigorra"
                                  #:user-initials "JJBA"
                                  #:user-email "jjbigorra@gmail.com"
                                  #:clone-dir (get-setting 'clone-dir)
                                  #:notes-roam-dir
                                  "$HOME/hacking/private-notes/roam"
                                  #:sans-font (get-setting 'sans-font)
                                  #:mono-font (get-setting 'mono-font))
                   (sss-nix-svc)
                   (sss-qt6-svc #:palette (get-setting 'palette))
                   (sss-containers-svc)
                   (sss-portals-svc)
                   (sss-enchant-svc))))

(display "
>>= configuring Joe's home environment...
")

(home-environment
  (services
   (append (list sss-home-files-service
                 (sss-ssh-service)
                 (sss-home-vars-service #:palette (get-setting 'palette)
                                        #:clone-dir (get-setting 'clone-dir)
                                        #:lang (get-setting 'lang))
                 (sss-bash-service #:clone-dir (get-setting 'clone-dir))
                 sss-openpgp-conf
                 (simple-service 'sss-home-cron-service
                                 home-mcron-service-type
                                 '())
                 (simple-service 'sss-random-wallpaper
                                 home-shepherd-service-type
                                 (list (shepherd-timer '(sss-random-wallpaper)
                                                       #~(cron-string->calendar-event
                                                          "*/10 * * * *")
                                                       `("sh" ,(format #f
                                                                "/home/joe/.local/bin/sss-wallpaper-random.sh")))))
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 sss-fontconfig-service-type
                 sss-channels-service) %base-home-services)))

