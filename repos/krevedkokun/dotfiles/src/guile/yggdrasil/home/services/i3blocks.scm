(define-module (yggdrasil home services i3blocks)
  #:use-module (rde serializers ini)
  #:use-module (gnu home services)
  #:use-module (gnu services configuration)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages wm)
  #:export (home-i3blocks-service-type
            home-i3blocks-configuration))

(define-configuration/no-serialization home-i3blocks-configuration
  (package
    (package i3blocks)
    "i3blocks package to use")
  (config
   (ini-config '())
   ""))

(define (add-i3blocks-configuration config)
  (let ((cfg (home-i3blocks-configuration-config config)))
    `(("i3blocks/config"
       ,(apply mixed-text-file
               "config"
               (ini-serialize cfg #:equal-string "="))))))

(define add-i3blocks-package
  (compose list home-i3blocks-configuration-package))

(define home-i3blocks-service-type
  (service-type
   (name 'home-i3blocks)
   (extensions
    (list (service-extension
           home-xdg-configuration-files-service-type
           add-i3blocks-configuration)
          (service-extension
           home-profile-service-type
           add-i3blocks-package)))
   (default-value (home-i3blocks-configuration))
   (description "")))
