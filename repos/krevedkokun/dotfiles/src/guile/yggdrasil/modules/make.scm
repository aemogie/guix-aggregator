(define-module (yggdrasil modules make)
  #:use-module (gnu home services)
  #:use-module ((gnu packages base) #:select (gnu-make))
  #:use-module (gnu services))

(define (home-services)
  (list
   (simple-service 'make-packages
     home-profile-service-type
     (list gnu-make))))
