(define-module (mrh-guix system base)
  #:use-module (gnu)
  #:use-module (nongnu packages linux))

(use-package-modules admin certs cryptsetup curl version-control)
(use-service-modules desktop networking ssh)

(define-public base-operating-system
  (operating-system
   (kernel linux)
   (firmware (list linux-firmware))
   (host-name "base-host")
   (timezone "America/New_York")
   (locale "en_US.utf8")
   (keyboard-layout (keyboard-layout "us" "dvorak"))

   (packages (cons* btop
                    cryptsetup
                    curl
                    git
                    %base-packages))

   (services
    (cons* (service wpa-supplicant-service-type)
           (service network-manager-service-type)
           (service ntp-service-type)
           (service openssh-service-type)
           (modify-services
            %base-services
            (guix-service-type
             config => (guix-configuration
                        (inherit config)
                        (authorized-keys
                         (cons* (local-file "../nonguix.pub")
                                %default-authorized-guix-keys))
                        (substitute-urls
                         (cons* "https://substitutes.nonguix.org"
                                %default-substitute-urls)))))))

   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

   (file-systems %base-file-systems)))
