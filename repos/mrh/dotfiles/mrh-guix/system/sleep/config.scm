(define-module (mrh-guix system sleep config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (gnu)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages firmware)
  #:use-module (nongnu system linux-initrd))

(use-package-modules admin cryptsetup curl cups version-control wm)
(use-service-modules cups dbus desktop networking ssh vpn xorg)

(define-public %sleep-operating-system
  (operating-system
    (kernel linux)
    (firmware (list linux-firmware))
    (host-name "sleep")
    (timezone "America/New_York")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us" "dvorak"))

    (groups (cons* (user-group (name "docker"))
                   (user-group (name "realtime"))
                   %base-groups))

    (users (cons (user-account
                   (name "mrh")
                   (group "users")
                   (home-directory "/home/mrh")
                   (supplementary-groups '("audio"
                                           "docker"
                                           "input"
                                           "lp"
                                           "netdev"
                                           "realtime"
                                           "video"
                                           "wheel")))
                 %base-user-accounts))

    (packages (cons* btop
                     cryptsetup
                     curl
                     git
                     fwupd-nonfree
                     %base-packages))

    (services
     (cons*
      (service wpa-supplicant-service-type)
      (service network-manager-service-type)
      (service ntp-service-type)

      (service openssh-service-type
			   (openssh-configuration
                 (port-number 2222)
                 (password-authentication? #f)
                 (max-connections 3)))

      (service elogind-service-type)

      (service bluetooth-service-type
               (bluetooth-configuration
                 (name "sleep")
                 (auto-enable? #t)))

      (service cups-service-type
               (cups-configuration
                 (web-interface? #t)))

      (service pam-limits-service-type
               (list (pam-limits-entry "@realtime" 'both 'rtprio 99)
                     (pam-limits-entry "@realtime" 'both 'memlock 'unlimited)
                     (pam-limits-entry "*" 'both 'nofile 100000)))

      (service screen-locker-service-type
               (screen-locker-configuration
                 (name "swaylock")
                 (program (file-append swaylock "/bin/swaylock"))))

      (service wireguard-service-type (wireguard-client-config 2))

      ;; doesn't work
      ;; (simple-service 'fwupd-dbus dbus-root-service-type
      ;;                 (list fwupd-nonfree))

      (modify-services %base-services
        (guix-service-type
         config => (guix-configuration
                     (inherit config)
                     (authorized-keys
                      (cons
                       (local-file (format #f "~a/nonguix.pub" %guix-dots-dir))
                       %default-authorized-guix-keys))
                     (substitute-urls
                      (cons "https://substitutes.nonguix.org"
                            %default-substitute-urls)))))))

    (bootloader (bootloader-configuration
                  (bootloader grub-efi-bootloader)
                  (targets (list "/boot/efi"))
                  (keyboard-layout keyboard-layout)))

    (swap-devices (list (swap-space
                          (target
                           (uuid "e5f30f68-8021-45bf-9768-5895f5c9eb54")))))

    (mapped-devices (list (mapped-device
                            (source (uuid "b7913f43-e874-4862-a40e-823cc136795c"))
                            (target "cryptroot")
                            (type luks-device-mapping))))

    (file-systems (cons* (file-system
                           (mount-point "/")
                           (device "/dev/mapper/cryptroot")
                           (type "ext4")
                           (dependencies mapped-devices))
                         (file-system
                           (mount-point "/boot/efi")
                           (device (uuid "F6FD-DB47" 'fat32))
                           (type "vfat"))
                         %base-file-systems))))

%sleep-operating-system
