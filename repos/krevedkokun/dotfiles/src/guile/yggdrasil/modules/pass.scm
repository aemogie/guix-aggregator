(define-module (yggdrasil modules pass)
  #:use-module ((gnu home-services password-utils)
                #:select (home-password-store-service-type))
  #:use-module (gnu services))

(define (home-services)
  (list
   (service home-password-store-service-type)))
