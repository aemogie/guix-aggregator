(define-module (yggdrasil modules engineering)
  #:use-module (gnu home services)
  #:use-module ((gnu packages engineering)
                #:select (prusa-slicer
                          openscad))
  #:use-module (gnu services))

(define (home-services)
  (list
   (simple-service 'engineering-packages
    home-profile-service-type
    (list prusa-slicer openscad))))
