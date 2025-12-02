(define-module (misako operating-systems install)
  #:use-module (misako substitute-keys)
  #:use-module ((misako channels) #:prefix channels:)
  #:use-module (guix channels)
  #:use-module (guix gexp)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages version-control)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu system)
  #:use-module (gnu system install)
  #:use-module (nongnu packages linux)
  #:use-module (saayix services system rfkill)
  #:export (installation-os-misako))

(define %channels
  (list channels:guix
        channels:nonguix
        channels:saayix
        channels:radix
        channels:sops-guix))

(define installation-os-misako
  (operating-system
    (inherit installation-os)
    (kernel linux)
    (firmware (list linux-firmware))
    (packages
      (cons* curl
             git
             helix
             (operating-system-packages installation-os)))
    (services
      (cons* (service rfkill-service-type)
             (modify-services (operating-system-user-services installation-os)
               (guix-service-type
                 config => (guix-configuration
                             (inherit config)
                             (guix (guix-for-channels %channels))
                             (authorize-key? #t)
                             (authorized-keys
                               (cons* nonguix.pub
                                      yumiko.pub
                                      %default-authorized-guix-keys))
                             (substitute-urls
                               '("https://ci.guix.gnu.org"
                                 "https://substitutes.nonguix.org"
                                 "https://bordeaux.guix.gnu.org"))
                             (channels %channels)
                             (extra-options '("--max-jobs=6"
                                              "--cores=0")))))))))

installation-os-misako
