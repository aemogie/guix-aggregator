;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2022 unwox <me@unwox.com>
;;;
;;; This file is not part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (home services foot)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu packages terminals)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix records)

  #:export (home-foot-configuration
            home-foot-server
            home-foot-service-type))

(define-configuration/no-serialization home-foot-server
  (display
   (string "wayland-0")
   "Wayland display to run the server on.")
  (config-file
   (file-like (plain-file "foot.ini" ""))
   "File-like to use as the foot.ini file."))

(define-configuration/no-serialization home-foot-configuration
  (foot
   (package foot)
   "The package providing @file{/bin/foot}.")
  (servers
   (list '())
   "List of servers to start"))

(define (form-socket-path display)
  #~(format #f (or (getenv "XDG_RUNTIME_DIR")
                     (format #f "/run/user/~a"
                             (getuid)))
                 "/foot-"
                 display
                 ".sock"))

(define (home-foot-profile-packages config)
  (list (home-foot-configuration-foot config)))

(define (home-foot-shepherd-services config)
  (map
   (lambda (sc)
     (shepherd-service
      (provision
       (list (string->symbol
              (format #f "foot-~a"
                      (home-foot-server-display sc)))))
      (documentation "Start the foot server daemon.")
      (start
       #~(make-systemd-constructor
            (list #$(file-append
                     (home-foot-configuration-foot config)
                     "/bin/foot")
                  "-s3" "-c" #$(home-foot-server-config-file sc))
            (list (endpoint
                   (make-socket-address
                    AF_UNIX
                    (format #f "~a/foot-~a.sock"
                            (or (getenv "XDG_RUNTIME_DIR")
                                (format #f "/run/user/~a"
                                        (getuid)))
                            #$(home-foot-server-display sc)))))
            #:environment-variables
            (append (default-environment-variables)
                    (list (string-append
                           "WAYLAND_DISPLAY="
                           #$(home-foot-server-display sc))))
            #:log-file
            (format #f "~a/log/foot-~a.log"
                    (or (getenv "XDG_STATE_HOME")
                        (format #f "~a/.local/state"
                                (getenv "HOME")))
                    #$(home-foot-server-display sc))))
      (stop #~(make-systemd-destructor))))
   (home-foot-configuration-servers config)))

(define home-foot-service-type
  (service-type
   (name 'home-foot)
   (extensions
    (list (service-extension home-profile-service-type
                             home-foot-profile-packages)
          (service-extension home-shepherd-service-type
                             home-foot-shepherd-services)))
   (default-value (home-foot-configuration))
   (description
    "Run foot server, minimalistic terminal emulator for Wayland.")))
