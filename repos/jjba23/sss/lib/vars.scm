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

(define-module (sss vars)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu services))

;; Environment variables for a user, plug into SSS
(begin
  (define* (sss-home-vars #:key clone-dir lang)
    `(("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale") ("LANG" unquote
                                                           (format #f
                                                                   "~a.UTF-8"
                                                                   lang))
      ("LANGUAGE" unquote lang)
      ("XDG_SESSION_TYPE" . "wayland")
      ("MOZ_ENABLE_WAYLAND" . "1")
      ("QT_QPA_PLATFORM" . "wayland;xcb")
      ("QT_QPT_PLATFORM" . "wayland;xcb")
      ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")
      ("QT_AUTO_SCREEN_SCALE_FACTOR" . "1")
      ("RTC_USE_PIPEWIRE" . "true")
      ("TERM" . "xterm-256color")
      ("HISTTIMEFORMAT" . "%F %T  | ")
      ("HISTSIZE" . "200000")
      ("HISTCONTROL" . "ignoreboth:erasedups")
      ("HISTFILESIZE" . "200000")
      ("XCURSOR_SIZE" . "24")
      ("XCURSOR_THEME" . "Yaru")
      ("CC" . "/run/current-system/profile/bin/gcc")
      ("SDL_VIDEODRIVER" . "wayland")
      ("_JAVA_AWT_WM_NONREPARENTING" . "1")
      ("XDG_DATA_DIRS" unquote
       (format #f
        "$XDG_DATA_DIRS:$HOME/.nix-profile/share:$HOME/.local/share/flatpak/exports/share"))
      ("INFOPATH" unquote
       (format #f "$INFOPATH:~a/docs/Manual" clone-dir))
      ("DOCKER_HOST" . "unix:///tmp/podman.sock")))
  (export sss-home-vars))

;; Environment variables Guix service for a user, plug into SSS
(begin
  (define* (sss-home-vars-service #:key clone-dir lang)
    (simple-service 'sss-home-vars-service
                    home-environment-variables-service-type
                    (sss-home-vars #:clone-dir clone-dir
                                   #:lang lang)))
  (export sss-home-vars-service))
