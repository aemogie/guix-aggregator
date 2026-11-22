(define-module (aetheria hosts mirae)
  #:use-module ((gnu system) #:select (operating-system
                                        this-operating-system))
  #:use-module ((gnu system linux-initrd) #:select (%base-initrd-modules))
  #:use-module ((gnu system accounts) #:select (user-account-name))
  #:use-module ((gnu system shadow) #:select (%base-user-accounts))
  #:use-module ((gnu services) #:select (service simple-service))
  #:use-module ((gnu services guix) #:select (guix-home-service-type))
  #:use-module ((gnu home) #:select (home-environment))
  #:use-module ((nongnu packages linux) #:select (linux
                                                  linux-firmware
                                                  sof-firmware))
  #:use-module ((nongnu system linux-initrd) #:select (microcode-initrd))
  #:use-module ((aetheria system base) #:select (%aetheria-base-system
                                                 aetheria-base-services))
  #:use-module ((aetheria hosts mirae file-systems) #:select (mirae-file-systems
                                                               mirae-persist))
  #:use-module ((aetheria users aemogie) #:select (make-aemogie-home
                                                   aemogie-account))
  #:use-module ((aetheria home services desktop) #:select (%aetheria-desktop-home-services))
  #:export (mirae
            mirae-with-nonfree))

(define mirae
  (operating-system
    (inherit %aetheria-base-system)
    (host-name "mirae")
    (timezone "Asia/Colombo")
    (file-systems mirae-file-systems)
    (users (cons* aemogie-account %base-user-accounts))
    (services
     (cons*
      (simple-service
       'mirae-home-environments
       guix-home-service-type
       (list (list (user-account-name aemogie-account) (make-aemogie-home host-name))))
      mirae-persist
      (aetheria-base-services this-operating-system)))))

(define mirae-with-nonfree
  (operating-system
    (inherit mirae)
    (kernel linux)
    (initrd microcode-initrd)
    (firmware (list linux-firmware sof-firmware))))

;; consumed by (@ (aetheria) system-config)
mirae-with-nonfree
