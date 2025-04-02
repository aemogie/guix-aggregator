(define-module (mrh-guix install)
  #:use-module (guix channels)
  #:use-module (guix gexp)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu system)
  #:use-module (gnu system install)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(use-package-modules curl package-management version-control text-editors)

(define %channels
  (load "install-channels.scm"))

(operating-system
 (inherit installation-os)
 (kernel linux)
 (firmware (list linux-firmware))

 (packages
  (cons* curl
         git
         mg
         (operating-system-packages installation-os)))

 (services
  (cons* (simple-service 'nonguix-pub etc-service-type
                         `(("nonguix-pub" ,(local-file "nonguix.pub"))))
         (simple-service 'channels-file etc-service-type
                         `(("channels" ,(local-file "install-channels.scm"))))
         (simple-service 'basic-config etc-service-type
                         `(("basic-config" ,(local-file "system/base.scm"))))
         (simple-service 'advanced-config etc-service-type
                         `(("advanced-config" ,(local-file "system/lap.scm"))))

         (modify-services
          (operating-system-user-services installation-os)
          (guix-service-type
           config => (guix-configuration
                      (inherit config)
                      (guix (guix-for-channels %channels))
                      (authorized-keys
                       (cons (local-file "nonguix.pub")
                             %default-authorized-guix-keys))
                      (substitute-urls
                       (cons "https://substitutes.nonguix.org"
                             %default-substitute-urls))
                      (channels %channels)))))))
