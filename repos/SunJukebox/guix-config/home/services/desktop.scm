(define-module (home services desktop)
  #:use-module (gnu)
  #:use-module (gnu packages))

(define (home-desktop-profile-service config)
  (list ;; window manager
        sway swayidle swaylock foot fuzzel mako grimshot))
