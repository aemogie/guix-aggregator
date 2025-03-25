(define-module (yggdrasil modules foot)
  #:use-module (gnu home services)
  #:use-module ((gnu packages terminals) #:select (foot))
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(define (home-services)
  (list
   (simple-service 'foot-packages
     home-profile-service-type
     (list foot))
   (simple-service 'sway-bindsym-foot
     home-sway-service-type
     `(( bindsym
         (($mod+Return exec ,(file-append foot "/bin/foot"))))))))
