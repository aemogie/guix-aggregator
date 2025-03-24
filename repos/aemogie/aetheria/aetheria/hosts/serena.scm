(define-module (aetheria hosts serena)
  #:use-module ((gnu system) #:select (operating-system))
  #:use-module ((gnu system linux-initrd) #:select (%base-initrd-modules))
  #:use-module ((gnu system accounts) #:select (user-account))
  #:use-module ((gnu system shadow) #:select (%base-user-accounts))
  #:use-module ((gnu services) #:select (simple-service))
  #:use-module ((gnu services guix) #:select (guix-home-service-type))
  #:use-module ((nongnu packages linux) #:select (linux
                                                  linux-firmware
                                                  sof-firmware))
  #:use-module ((nongnu system linux-initrd) #:select (microcode-initrd))
  #:use-module ((aetheria system base) #:select (%aetheria-base-system
                                                 %aetheria-base-services
                                                 %aetheria-user-template))
  #:use-module ((aetheria hosts serena file-systems) #:select (serena-file-systems))
  #:use-module ((aetheria users aemogie) #:select (make-aemogie-home))
  #:export (serena
            serena-with-nonfree))

(define serena-users ;; ((list of <user-account>s) . (list of <home-environment>s))
  ((lambda (users) (cons (map car users) (map cdr users)))
   (list
    (cons (user-account
           (inherit %aetheria-user-template)
           (name "aemogie"))
          (list "aemogie" (make-aemogie-home "serena"))))))

(define serena
  (operating-system
    (inherit %aetheria-base-system)
    (host-name "serena")
    (timezone "Asia/Colombo")
    (file-systems serena-file-systems)
    (users (append (car serena-users)
                   %base-user-accounts))
    (services
     (cons*
      (simple-service 'serena-home-environments guix-home-service-type (cdr serena-users))
      %aetheria-base-services))))

(define serena-with-nonfree
  (operating-system
    (inherit serena)
    (kernel linux)
    (initrd microcode-initrd)
    (initrd-modules
     (cons* "vmd" ;; intel vmd so it sees my disks
            %base-initrd-modules))
    (firmware (list linux-firmware sof-firmware))))

;; consumed by (@ (aetheria) system-config)
serena-with-nonfree
