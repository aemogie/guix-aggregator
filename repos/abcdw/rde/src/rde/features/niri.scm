;;; rde --- Reproducible development environment.
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later
;;;
;;; SPDX-FileCopyrightText: 2026 Andrew Tropin <andrew@trop.in>

(define-module (rde features niri)
  #:use-module (rde features)
  #:use-module ((rde system services greetd) #:prefix greetd:)
  #:use-module (gnu home services)
  #:use-module (gnu home services xdg)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages window-management)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:export (feature-niri))


;;;
;;; Niri.
;;;

(define* (feature-niri
          #:key
          (niri niri)
          (xdg-desktop-portal xdg-desktop-portal)
          (xdg-desktop-portal-gnome xdg-desktop-portal-gnome)
          (xdg-desktop-portal-gtk xdg-desktop-portal-gtk))
  "Feature providing niri as the primary Wayland compositor with portal
support for screencasting and other desktop integration."

  (define niri-cmd
    (file-append niri "/bin/niri"))

  (define env-vars
    `(("XDG_SESSION_TYPE" . "wayland")
      ;; Hardcode sway for now to make portal for selecting screen to share
      ;; work in bare-bone niri setup.
      ("XDG_CURRENT_DESKTOP" . "sway")
      ;; FIXME: Should be in feature-pipewire.
      ("RTC_USE_PIPEWIRE" . "true")
      ("SDL_VIDEODRIVER" . "wayland")
      ("MOZ_ENABLE_WAYLAND" . "1")
      ("CLUTTER_BACKEND" . "wayland")
      ("ELM_ENGINE" . "wayland_egl")
      ("ECORE_EVAS_ENGINE" . "wayland-egl")
      ("QT_QPA_PLATFORM" . "wayland-egl")
      ("_JAVA_AWT_WM_NONREPARENTING" . "1")))

  (define niri-greetd-login-session
    (greetd:greetd-login-session
     (name "niri")
     (command niri-cmd)
     (command-args '("--session"))
     (extra-env env-vars)
     (xdg-session-type "wayland")))

  (define (niri-home-services config)
    (list
     (simple-service
      'niri-portal-configuration
      home-xdg-configuration-files-service-type
      `(("xdg-desktop-portal/niri-portals.conf"
         ,(file-append niri
                       "/share/xdg-desktop-portal/niri-portals.conf"))))
     (simple-service
      'niri-portal-packages
      home-profile-service-type
      (list niri
            xdg-desktop-portal
            xdg-desktop-portal-gnome
            xdg-desktop-portal-gtk))))

  (define (niri-system-services config)
    (list
     (simple-service
      'niri-greetd-login-session
      greetd:greetd-greeter-service-type
      (list (greetd:greetd-login-session-with-dbus
             niri-greetd-login-session
             (get-value 'dbus config))))))

  (feature
   (name 'niri)
   (values `((niri . ,niri)
             (primary-wayland-compositor . niri)))
   (home-services-getter niri-home-services)
   (system-services-getter niri-system-services)))
