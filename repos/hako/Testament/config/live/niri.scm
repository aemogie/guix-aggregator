;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (gnu system)
             (gnu services)
             (gnu services guix)
             (rosenthal services desktop)
             (gnu home)
             (gnu services base)
             (rosenthal services base))

(define %graphical-home
  (load "graphical-home.scm"))

(define %graphical-os
  (load "graphical-system.scm"))


;;;
;;; Home environment
;;;

(define %home
  (home-environment
    (services
     (cons* (service home-noctalia-shell-service-type)
            (service home-polkit-gnome-service-type)
            (service home-swaybg-service-type)
            (home-environment-user-services %graphical-home)))))


;;;
;;; Operating system
;;;

(operating-system
  (inherit %graphical-os)
  (services
   (cons* (service guix-home-service-type
            `(("live" ,%home)))

          (service greetd-service-type
            (greetd-configuration
              (greeter-supplementary-groups '("video" "input"))
              (terminals
               (list (greetd-terminal-configuration
                       (terminal-vt "1")
                       (terminal-switch #t)
                       (initial-session-user "live")
                       (initial-session-command "dbus-run-session niri --session")
                       (default-session-command (greetd-tuigreet-session)))))))

          (operating-system-user-services %graphical-os))))
