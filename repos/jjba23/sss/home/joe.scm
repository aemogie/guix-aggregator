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
             (sss fastfetch)
             (sss user-timers)
             (sss enchant)
             (sss nix)
             (sss nyxt)
             (sss fontconfig)
             (sss wallpaper)
             (sss bash)
             (sss containers)
             (sss mime)
             (sss dconf)
             (sss fish)
             (sss gtk)
             (sss portals)
             (sss alacritty)
             (sss qt)
             (sss openpgp)
             (sss dirs)
             (sss waybar)
             (sss user-scripts)
             (sss rofi)
             (sss niri)
             (sss labwc)
             (sss ssh)
             (sss firefox)
             (sss emacs))

(setup-i18n)
(log-active-sss-settings)

(define sss-home-files-service
  (service home-files-service-type
           (append (gtk3-capability #:palette ($$$ 'palette)
                                    #:sans-font ($$$ 'sans-font))
                   (gtk4-capability #:palette ($$$ 'palette)
                                    #:sans-font ($$$ 'sans-font)
                                    #:mono-font ($$$ 'mono-font))
                   (git-capability)
                   (waybar-capability #:palette ($$$ 'palette)
                                      #:sans-font ($$$ 'sans-font)
                                      #:with-memory #t
                                      #:niri-session #t)
                   (rofi-capability #:palette ($$$ 'palette)
                                    #:sans-font ($$$ 'sans-font))
                   (alacritty-capability #:palette ($$$ 'palette)
                                         #:mono-font ($$$ 'mono-font))
                   (niri-capability #:palette ($$$ 'palette)
                                    #:keyboard-layout ($$$ 'niri-keyboard-layout)
                                    #:caps-to-ctrl? ($$$ 'caps-to-ctrl?)
                                    #:sans-font ($$$ 'sans-font)
                                    #:mono-font ($$$ 'mono-font)
                                    #:extra-startups ($$$ 'niri-extra-startups))
                   (mime-capability)
                   (dirs-capability)
                   (firefox-capability #:palette ($$$ 'palette))
                   (fastfetch-capability #:clone-dir ($$$ 'clone-dir))
                   (fish-capability #:clone-dir ($$$ 'clone-dir)
                                    #:palette ($$$ 'palette)
                                    #:gui-cmd
                                    "dbus-run-session niri --session")
                   (mako-capability #:palette ($$$ 'palette)
                                    #:sans-font ($$$ 'sans-font))
                   (emacs-capability #:palette ($$$ 'palette)
                                     #:user-name "Joe"
                                     #:user-full-name "Josep Bigorra"
                                     #:user-initials "JJBA"
                                     #:user-email "jjbigorra@gmail.com"
                                     #:clone-dir ($$$ 'clone-dir)
                                     #:notes-roam-dir
                                     "$HOME/hacking/private-notes/roam"
                                     #:sans-font ($$$ 'sans-font)
                                     #:mono-font ($$$ 'mono-font))
                   (nix-capability)
                   (nyxt-capability)
                   (qt6-capability #:palette ($$$ 'palette))
                   (containers-capability)
                   (portals-capability)
                   (enchant-capability)
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
                   (labwc-capability #:sans-font ($$$ 'sans-font)
                                     #:extra-startups ($$$ 'labwc-extra-startups))
                   ;; User Timer Scripts
                   (user-timer-script #:name 'set-random-wallpaper
                                      #:cmd (mk-random-wall-cmd (wallpapers
                                                                            #:clone-dir
                                                                            ($$$ 'clone-dir)
                                                                            #:palette
                                                                            ($$$ 'palette))))
                   (user-timer-script #:name 'remind-back-stretches
                                      #:cmd (format #f
                                             "zenity --info --text=\"~a\" --display=:0.0"
                                             (G_
                                              "It's time to stretch your back! Cobra, Child pose, Cat-cow!")))
                   (user-timer-script #:name 'remind-pushups-squats-situps
                                      #:cmd (format #f
                                             "zenity --info --text=\"~a\" --display=:0.0"
                                             (G_
                                              "It's time to move! Push-ups, squats and sit-ups!")))
                   ;; User Scripts
                   (user-script #:name 'restart-emacs
                                #:cmd (string-join (list (format #f
                                                          "zenity --question --text=\"~a\" &&"
                                                          (G_
                                                           "Do you really want to fully restart Emacs?"))
                                                         "pkill emacs &&"
                                                         "emacs --daemon"))))))

(define joe-shepherd-timers
  (list (user-timer #:user 'joe
                    #:name 'set-random-wallpaper
                    #:gexp #~(cron-string->calendar-event "*/10 * * * *"))
        (user-timer #:user 'joe
                    #:name 'remind-back-stretches
                    #:gexp #~(cron-string->calendar-event "15 9 * * 1-5"))
        (user-timer #:user 'joe
                    #:name 'remind-pushups-squats-situps
                    #:gexp #~(cron-string->calendar-event "45 12 * * 1-5"))))

(log-info (G_ "Configuring home environment for user: ~a") "joe")

(home-environment
  (services
   (append (list sss-home-files-service
                 (ssh-capability)
                 (env-variables-capability #:palette ($$$ 'palette)
                                           #:clone-dir ($$$ 'clone-dir)
                                           #:lang ($$$ 'lang)
                                           #:extra-vars `(("GH_PACKAGES_USERNAME" . "jjbavdb")
                                                          ("GH_PACKAGES_TOKEN" . "$(/home/joe/.nix-profile/bin/gh auth token)")))
                 (bash-capability #:clone-dir ($$$ 'clone-dir)
                                  #:gui-cmd "dbus-run-session niri --session")
                 openpgp-capability
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 (fontconfig-capability #:mono-font ($$$ 'mono-font)))
           joe-shepherd-timers %base-home-services)))

