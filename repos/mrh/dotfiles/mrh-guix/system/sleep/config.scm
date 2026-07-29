(define-module (mrh-guix system sleep config)
  #:use-module (mrh-guix personal)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages firmware)
  #:use-module (gnu)
  #:use-module (gnu services dns))

(use-package-modules admin cryptsetup curl cups nfs version-control window-management)
(use-service-modules cups dbus desktop networking ssh syncthing vpn xorg)

(define-public %sleep-operating-system
  (operating-system
    (kernel linux)
    (firmware (list linux-firmware))
    (host-name "sleep")
    (timezone "America/New_York")
    (locale "en_US.utf8")
    (keyboard-layout (keyboard-layout "us" "dvorak"))

    (bootloader
      (bootloader-configuration
        (bootloader grub-efi-bootloader)
        (targets (list "/boot/efi"))
        (keyboard-layout keyboard-layout)))

    (swap-devices
     (list (swap-space
             (target (uuid "e5f30f68-8021-45bf-9768-5895f5c9eb54")))))

    (mapped-devices
     (list (mapped-device
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
                         %base-file-systems))

    (groups (cons* (user-group (name "docker"))
                   (user-group (name "realtime"))
                   %base-groups))

    (users (cons (user-account
                   (name %username)
                   (group "users")
                   (home-directory %user-home)
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
                     nfs-utils
                     %base-packages))

    (services
     (cons*
      (service
       wpa-supplicant-service-type)

      (service
       network-manager-service-type)
      
      (service
       ntp-service-type)

      (service
       nftables-service-type
       (nftables-configuration
         (ruleset (local-file "nftables.conf"))))

      (service
       openssh-service-type
       (openssh-configuration
         (port-number %ssh-port)
         (password-authentication? #f)
         (max-connections 5)))

      (service
       elogind-service-type)

      (service
       syncthing-service-type
       (syncthing-configuration
         (user %username)
         (config-file
          (syncthing-config-file
            (gui-address "[::1]:8384")
            (gui-user "wumpus")
            (gui-password %syncthing-password)
            (folders
             (let ((om (syncthing-device
                         (name "om")
                         (id %om-syncthing-id)))
                   (smoulder (syncthing-device
                               (name "smoulder")
                               (id %smoulder-syncthing-id)))
                   (lamb (syncthing-device
                           (name "lamb")
                           (id %lamb-syncthing-id))))
               (list (syncthing-folder
                       (id "default")
                       (label "default")
                       (path (format #f "~a/sync" %user-home))
                       (devices (list om smoulder lamb)))
                     (syncthing-folder
                       (id "paperless-upload")
                       (label "paperless-upload")
                       (path (format #f "~a/data/paperless" %user-home))
                       (devices (list om smoulder lamb))))))))))

      (service
       bluetooth-service-type
       (bluetooth-configuration
         (name "sleep")
         (auto-enable? #t)))

      (service
       cups-service-type
       (cups-configuration
         (web-interface? #t)))

      ;; I don't remember what this is...
      (service
       pam-limits-service-type
       (list (pam-limits-entry "@realtime" 'both 'rtprio 99)
             (pam-limits-entry "@realtime" 'both 'memlock 'unlimited)
             (pam-limits-entry "*" 'both 'nofile 100000)))

      (service
       screen-locker-service-type
       (screen-locker-configuration
         (name "swaylock")
         (program (file-append swaylock "/bin/swaylock"))
         (using-pam? #t)
         (using-setuid? #f)))

      (service
       yggdrasil-service-type
       (yggdrasil-configuration
         (config-file
          (format #f "~a/.config/yggdrasil/yggdrasil-private.conf" %user-home))
         (json-config
          '((peers . #("tcp://marisa.nadeko.net:44441"
                       "tls://ygg.jjolly.dev:3443"))))))

      (service
       wireguard-service-type
       (wireguard-configuration
         (addresses
          (list %ipv6-wireguard-sleep
                %ipv4-wireguard-sleep))
         (port %wireguard-port)
         (peers
          (list (wireguard-peer
                  ;; (name "om")
                  ;; (endpoint (format #f "[~a]:~a" %ipv6-gua-om %wireguard-port))
                  ;; (public-key %om-wireguard-key)
                  (name "vps")
                  (endpoint (format #f "~a:~a" %domain-name %wireguard-port))
                  (public-key %vps-wireguard-key)
                  (allowed-ips '("::/0" "0.0.0.0/0")))))
         (dns
          ;; (list %ipv6-wireguard-om
          ;;       %ipv4-wireguard-om)
          (list %ipv6-wireguard-vps
                %ipv4-wireguard-vps))))

      ;; doesn't work?
      (simple-service
       'fwupd-dbus
       dbus-root-service-type
       (list fwupd-nonfree))

      (modify-services %base-services
        (guix-service-type
         config => (guix-configuration
                     (inherit config)
                     (authorized-keys
                      (cons*
                       (local-file (format #f "~a/sleep-guix.pub" %guix-dots-dir))
                       (local-file (format #f "~a/vps-guix.pub" %guix-dots-dir))
                       (local-file (format #f "~a/nonguix.pub" %guix-dots-dir))
                       %default-authorized-guix-keys))
                     (substitute-urls
                      (cons "https://substitutes.nonguix.org"
                            %default-substitute-urls)))))))))

%sleep-operating-system
