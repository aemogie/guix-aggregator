(define-module (mrh-guix home nvidia config)
  #:use-module (mrh-guix home nvidia packages)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu system shadow)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound))

(define-public %nvidia-home-config
  (home-environment
    (packages %nvidia-home-packages)
    (services
     (list
      (service home-dbus-service-type)
      (service home-pipewire-service-type)))))

%nvidia-home-config
