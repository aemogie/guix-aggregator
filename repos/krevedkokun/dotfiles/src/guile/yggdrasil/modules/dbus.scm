(define-module (yggdrasil modules dbus)
  #:use-module ((gnu home services desktop) #:select (home-dbus-service-type))
  #:use-module ((gnu packages glib) #:select (dbus))
  #:use-module (gnu services)
  #:use-module ((gnu services dbus) #:select (dbus-root-service-type))
  #:use-module (guix gexp)
  #:use-module ((rde home services wm) #:select (home-sway-service-type)))

(define (home-services)
  (list
   (service home-dbus-service-type)
   (simple-service 'dbus-update-env
     home-sway-service-type
     `((exec ,(file-append dbus "/bin/dbus-update-activation-environment")
             WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY SWAYSOCK)))))

(define (system-services)
  (list
   (service dbus-root-service-type)))
