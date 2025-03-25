(define-module (yggdrasil home services swappy)
  #:use-module (rde serializers ini)
  #:use-module (gnu home services)
  #:use-module (gnu services configuration)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages image)
  #:export (home-swappy-configuration
            home-swappy-service-type))

(define-configuration/no-serialization home-swappy-configuration
  (package
    (package swappy)
    "swappy package to use")
  (config
   (ini-config '())
   ""))

(define (add-swappy-configuration config)
  (let ((cfg (home-swappy-configuration-config config)))
    `(("swappy/config"
       ,(apply mixed-text-file
               "config"
               (ini-serialize cfg #:equal-string "="))))))

(define add-swappy-package
  (compose list home-swappy-configuration-package))

(define home-swappy-service-type
  (service-type
   (name 'home-swappy)
   (extensions
    (list (service-extension
           home-xdg-configuration-files-service-type
           add-swappy-configuration)
          (service-extension
           home-profile-service-type
           add-swappy-package)))
   (default-value (home-swappy-configuration))
   (description "")))
