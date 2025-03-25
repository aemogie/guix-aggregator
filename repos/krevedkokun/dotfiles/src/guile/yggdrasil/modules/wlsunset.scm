(define-module (yggdrasil modules wlsunset)
  #:use-module (gnu home services)
  #:use-module ((gnu packages xdisorg) #:select (wlsunset))
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(define (home-services)
  (list
   (simple-service 'tofi-packages
     home-profile-service-type
     (list wlsunset))
   (simple-service 'sway-exet-wlsunset
     home-sway-service-type
     `((exec ,(file-append wlsunset "/bin/wlsunset")
             -l 42.88 -L 74.58 -T 6500 -t 3000)))))
