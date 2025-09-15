(define-module (mrh-guix system nvidia config)
  #:use-module (mrh-guix personal)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu services nvidia)
  #:use-module (nongnu system linux-initrd)
  #:use-module (gnu))

(use-package-modules admin
                     compton
                     cryptsetup
                     curl
                     package-management
                     tls
                     version-control
                     wm)

(use-service-modules cups
                     dbus
                     desktop
                     networking
                     sddm
                     xorg)

(define-public %nvidia-operating-system
  (operating-system
    (kernel linux)
    (kernel-arguments (cons "modprobe.blacklist=nouveau"
                            %default-kernel-arguments))
    (firmware (list linux-firmware))
    (initrd microcode-initrd)
    (host-name "guix-nvidia")
    (timezone "America/New_York")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us" "dvorak"))

    (users (cons (user-account
                   (name "mrh")
                   (group "users")
                   (home-directory "/home/mrh")
                   (supplementary-groups '("wheel"
                                           "netdev"
                                           "audio"
                                           "video"
                                           "input"
                                           "lp")))
                 %base-user-accounts))

    (packages (map replace-mesa (cons* btop
                                       cryptsetup
                                       curl
                                       git
                                       i3-wm
                                       i3blocks
                                       openssl
                                       picom
                                       %base-packages)))

    (services
     (cons*
      (service wpa-supplicant-service-type)
      (service network-manager-service-type)
      (service ntp-service-type)

      (service bluetooth-service-type
               (bluetooth-configuration
                 (name "guix-box")))

      (service cups-service-type
               (cups-configuration
                 (web-interface? #t)))

      (service nvidia-service-type)
      
      (set-xorg-configuration
       (xorg-configuration
         (keyboard-layout keyboard-layout)
         (modules (cons nvda %default-xorg-modules))
         (drivers '("nvidia")))
       sddm-service-type)

      (modify-services %base-services
        (guix-service-type
         config => (guix-configuration
                     (inherit config)
                     (authorized-keys
                      (cons*
                       (local-file (format #f "~a/nonguix.pub" %guix-dots-dir))
                       %default-authorized-guix-keys))
                     (substitute-urls
                      (cons* "https://substitutes.nonguix.org"
                             %default-substitute-urls)))))))

    (bootloader (bootloader-configuration
                  (bootloader grub-efi-bootloader)
                  (targets (list "/boot/efi"))
                  (keyboard-layout keyboard-layout)))

    (swap-devices (list (swap-space
                          (target
                           (uuid "REPLACE-ME")))))

    (file-systems
     (cons* (file-system (mount-point "/")
                         (device
                          (uuid "REPLACE-ME" 'ext4))
                         (type "ext4"))
            (file-system (mount-point "/boot/efi")
                         (device (uuid "REPLACE-ME" 'fat32))
                         (type "vfat"))
            %base-file-systems))))

%nvidia-operating-system
