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
  #:declarative? #t
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (sss palette)
  #:use-module (gnu services)
  #:export (env-variables-capability))

(define* (env-variables-capability #:key palette
                                   (extra-vars '())
                                   (clone-dir "$HOME/hacking/sss")
                                   (lang "en_US")
                                   (desktop-dir "$HOME/desktop")
                                   (documents-dir "$HOME/documents")
                                   (downloads-dir "$HOME/downloads")
                                   (music-dir "$HOME/music")
                                   (pictures-dir "$HOME/pictures")
                                   (public-dir "$HOME/public")
                                   (templates-dir "$HOME/templates")
                                   (videos-dir "$HOME/videos"))
  "Environment variables Guix service for a user, plug into SSS"
  (let ((home-v `(("GUIX_LOCPATH" . "$HOME/.guix-profile/lib/locale") ("LANG"
                                                                       unquote
                                                                       (format
                                                                        #f
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
                  ("XCURSOR_THEME" unquote
                   (get-cursor-theme palette))
                  ("CC" . "/run/current-system/profile/bin/gcc")
                  ("SDL_VIDEODRIVER" . "wayland")
                  ("_JAVA_AWT_WM_NONREPARENTING" . "1")
                  ("XDG_DATA_DIRS" unquote
                   (format #f
                    "$XDG_DATA_DIRS:$HOME/.nix-profile/share:$HOME/.local/share/flatpak/exports/share"))
                  ("DOCKER_HOST" . "unix:///tmp/podman.sock")
                  ("XDG_DESKTOP_DIR" unquote desktop-dir)
                  ("XDG_DOCUMENTS_DIR" unquote documents-dir)
                  ("XDG_DOWNLOAD_DIR" unquote downloads-dir)
                  ("XDG_MUSIC_DIR" unquote music-dir)
                  ("XDG_PICTURES_DIR" unquote pictures-dir)
                  ("XDG_PUBLICSHARE_DIR" unquote public-dir)
                  ("XDG_TEMPLATES_DIR" unquote templates-dir)
                  ("XDG_VIDEOS_DIR" unquote videos-dir))))
    (simple-service 'env-variables-capability
                    home-environment-variables-service-type
                    (append extra-vars home-v))))

