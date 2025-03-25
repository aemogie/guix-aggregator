(define-module (mrh-guix system lap)
  #:use-module (mrh-guix vpn)
  #:use-module (mrh-guix system base)

  #:use-module (gnu)
  #:use-module (gnu packages wm)

  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(use-service-modules cups desktop vpn xorg)

(define-public lap-operating-system
  (operating-system
   (inherit base-operating-system)
   (initrd microcode-initrd)
   (host-name "guix-lap")

   (groups (append (map (lambda (group-name)
                          (user-group (name group-name)))
                        (list "realtime" "docker"))
                   %base-groups))

   (users (cons* (user-account
                  (name "mrh")
                  (group "users")
                  (home-directory "/home/mrh")
                  (supplementary-groups
                   (list "audio"
                         "docker"
                         "input"
                         "lp"
                         "netdev"
                         "realtime"
                         "video"
                         "wheel")))
                 %base-user-accounts))

   (services
    (cons*
     (service elogind-service-type)
     (service bluetooth-service-type
              (bluetooth-configuration
               (name "guix-lap")))

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

	 (service wireguard-service-type
              (wireguard-client-config 2))

     (operating-system-user-services base-operating-system)))

   (swap-devices (list (swap-space
                        (target
                         (uuid "85bdc49e-4d97-429e-837f-79d68bc568ef")))))

   (mapped-devices (list (mapped-device
                          (source (uuid "2f82db46-4d80-4e91-9ba6-72c3ef78b536"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

   (file-systems (cons* (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices))
                        (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "1921-C31A" 'fat32))
                         (type "vfat"))
                        %base-file-systems))))

lap-operating-system
