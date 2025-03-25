(define-module (yggdrasil modules nyxt)
  #:use-module (gnu home services)
  #:use-module ((gnu packages web-browsers) #:select (nyxt))
  #:use-module (gnu services)
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(define (home-services)
  (list
   (simple-service 'nyxt-package
     home-profile-service-type
     (list nyxt))
   (simple-service 'sway-nyxt-config
     home-sway-service-type
     `((assign "[app_id=\"nyxt\"]" WEB)))))
