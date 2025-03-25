(define-module (yggdrasil modules seatd)
  #:use-module (gnu services)
  #:use-module ((gnu services desktop) #:select (seatd-service-type)))

#;(define (home-services)
  (list
   (simple-service 'sway-bindsym-loginctl
     home-sway-service-type
     `(( bindsym
         (($mod+l exec ,(file-append elogind "/bin/loginctl") lock-session)))))))

(define (system-services)
  (list
   (service seatd-service-type)))
