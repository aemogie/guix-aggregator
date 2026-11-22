(define-module (aetheria hosts lettr)
  #:use-module ((gnu system) #:select (operating-system
                                        operating-system-bootloader
                                        operating-system-file-systems))
  #:use-module ((gnu system install) #:select (installation-os))
  #:use-module ((nongnu packages linux) #:select (linux
                                                  linux-firmware))
  #:use-module ((nongnu system linux-initrd) #:select (microcode-initrd))
  #:use-module ((aetheria system base) #:select (%aetheria-base-system
                                                 %aetheria-user-template))
  #:use-module ((aetheria users aemogie) #:select (aemogie-account)))

(define lettr
  (operating-system
    (inherit %aetheria-base-system)
    (users (list aemogie-account))))

(define lettr-with-nonfree
  (operating-system
    (inherit lettr)
    (kernel linux)
    (firmware (list linux-firmware))))

lettr-with-nonfree
