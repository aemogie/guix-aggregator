(define-module (mrh-guix services fnott)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd))

(define (home-fnott-service)
  (shepherd-service
   (documentation "fnott notification daemon")
   (provision '(fnott))
   (requirement '(dbus))
   (start #~(make-forkexec-constructor
             (list "/bin/fnott")))
   (stop #~(make-kill-destructor))))

(define-public home-fnott-service-type
  (service-type
   (name 'fnott)
   (extensions
    (list (service-extension home-shepherd-service-type
                             home-fnott-service)))
   (description "start fnott daemon")))
