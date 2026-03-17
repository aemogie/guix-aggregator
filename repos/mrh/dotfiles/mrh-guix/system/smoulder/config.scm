(define-module (mrh-guix system smoulder config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix web)
  #:use-module (mrh-guix oci-containers)
  #:use-module (mrh services)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:use-module (gnu))

(use-package-modules admin
                     cryptsetup
                     curl
                     dns
                     package-management
                     rsync
                     tls
                     version-control)

(use-service-modules containers
                     dbus
                     desktop
                     dns
                     docker
                     networking
                     nfs
                     ssh
                     syncthing
                     sysctl
                     vpn
                     web)

(operating-system
  (kernel linux)
  (firmware (list linux-firmware))
  (initrd microcode-initrd)
  (initrd-modules (cons* "vmd" %base-initrd-modules))
  (host-name "smoulder")
  (timezone "America/New_York")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "us" "dvorak"))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

  (file-systems
   (cons* (file-system (mount-point "/")
                       (device
                        (uuid "c0c2d7e9-abfa-478f-abc6-01ef1ec0262a" 'ext4))
                       (type "ext4"))
          (file-system (mount-point "/boot/efi")
                       (device (uuid "5E8C-6F8B" 'fat32))
                       (type "vfat"))
          %base-file-systems))

  (users (cons (user-account
                 (name %username)
                 (group "users")
                 (supplementary-groups '("wheel"
                                         "docker"
                                         "netdev"
                                         "audio"
                                         "video"
                                         "input"
                                         "lp"))
                 (home-directory %user-home))
               %base-user-accounts))

  (packages (cons* btop
                   cryptsetup
                   curl
                   git
                   rsync
                   stow
                   %base-packages))

  (services
   (cons*
    (service
     elogind-service-type
     (elogind-configuration
       (handle-lid-switch 'ignore)
       (handle-lid-switch-docked 'ignore)
       (handle-lid-switch-external-power 'ignore)))

    (service
     nftables-service-type
     (nftables-configuration
       (ruleset (local-file "nftables.conf"))))

    (service
     static-networking-service-type
     (list (static-networking
             (addresses
              (list (network-address
                      (device %smoulder-wlan-interface)
                      (value (format #f "~a/64" %ipv6-ula-smoulder)))
                    (network-address
                      (device %smoulder-wlan-interface)
                      (value (format #f "~a/64" %ipv6-gua-smoulder)))
                    (network-address
                      (device %smoulder-wlan-interface)
                      (value (format #f "~a/24" %ipv4-lan-smoulder)))))
             (routes
              (list (network-route
                      (device %smoulder-wlan-interface)
                      (destination "default")
                      (gateway %ipv6-lan-gateway))
                    (network-route
                      (device %smoulder-wlan-interface)
                      (destination "default")
                      (gateway %ipv4-lan-gateway))))
             (name-servers
              (list
               %ipv4-wireguard-vps
               "9.9.9.9"
               %ipv6-wireguard-vps
               "2620:fe::9")))))

    (service
     wpa-supplicant-service-type
     (wpa-supplicant-configuration
       (interface %smoulder-wlan-interface)
       (config-file (local-file "wpa-supplicant.conf"))))

    (service
     ntp-service-type)

    (service
     openssh-service-type
     (openssh-configuration
       (port-number %ssh-port)
       (password-authentication? #f)
       (permit-root-login 'prohibit-password)))

    (service
     wireguard-service-type
     (wireguard-configuration
       (addresses
        (list %ipv6-wireguard-smoulder
              %ipv4-wireguard-smoulder))
       (port %wireguard-port)
       (peers
        (list (wireguard-peer
                (name "vps")
                (endpoint (format #f "~a:~a" %domain-name %wireguard-port))
                (public-key %vps-wireguard-key)
                (allowed-ips
                 (list (format #f "~a::/64" %ipv6-wireguard-prefix)
                       (format #f "~a.0/24" %ipv4-wireguard-prefix)))
                (keep-alive 60))

              ;; (wireguard-peer
              ;;   (name "sleep")
              ;;   (public-key %sleep-wireguard-key)
              ;;   (allowed-ips
              ;;    (list %ipv6-wireguard-sleep
              ;;          %ipv4-wireguard-sleep)))
              ))))

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
                 (sleep (syncthing-device
                          (name "sleep")
                          (id %sleep-syncthing-id)))
                 (lamb (syncthing-device
                         (name "lamb")
                         (id %lamb-syncthing-id))))
             (list (syncthing-folder
                     (id "default")
                     (label "default")
                     (path "~/sync")
                     (devices (list om sleep lamb)))
                   (syncthing-folder
                     (id "paperless-upload")
                     (label "paperless-upload")
                     (path (format #f "~a/data/paperless" %user-home))
                     (devices (list om sleep lamb))))))))))

    (service
     containerd-service-type)
    (service
     docker-service-type)

    (simple-service
     'oci-provisioning
     oci-service-type
     (oci-extension
      (networks
       (list (oci-network-configuration
              (name "media"))
             (oci-network-configuration
              (name "paperless"))
             (oci-network-configuration
              (name "immich"))))
      (containers
       (append %homepage-oci
               %paperless-oci
               %sabnzbd-oci
               %arrs-oci
               %jellyfin-oci))))

    (service
     copyparty-service-type
     (copyparty-configuration
      (user "oci-container")
      (group "users")
      (conf (local-file
             (format #f "~a/copyparty.conf" %guix-dots-dir)))))

    (service
     nginx-service-type
     (nginx-configuration
       (shepherd-requirement '(wireguard-wg0))
       (server-blocks
        (let ((local-app-server-block
               (lambda* (name port #:key (additional-names '()) (extra '()))
                 (app-server-block
                  name %ipv6-wireguard-smoulder "::1"
                  #:port port
                  #:additional-names additional-names
                  #:extra extra)))
              (proxy-headers '("proxy_set_header Host $host;"
                               "proxy_set_header X-Real-IP $remote_addr;"
                               "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                               "proxy_set_header X-Forwarded-Proto $scheme;"
                               "proxy_set_header X-Forwarded-Protocol $scheme;"
                               "proxy_set_header X-Forwarded-Host $http_host;"
                               "proxy_buffering off;")))
          (list (root-server-block
                 "lan" %ipv6-wireguard-smoulder)
                (root-server-block
                 "home" %ipv6-wireguard-smoulder)
                (local-app-server-block
                 "files.home" 3939
                 #:extra proxy-headers)
                (local-app-server-block
                 "sync.home" 8384)
                (local-app-server-block
                 "homepage.home" 3000
                 #:extra proxy-headers)
                (local-app-server-block
                 "paper.home" 8000)
                ;; (local-app-server-block
                ;;  "immich.home" 2283)
                (local-app-server-block
                 "sab.home" 8081)
                (local-app-server-block
                 "radarr.home" 7878)
                (local-app-server-block
                 "sonarr.home" 8989)
                (local-app-server-block
                 "jelly.home" 8096
                 #:additional-names '("jelly")
                 #:extra proxy-headers))))))

    (modify-services %base-services
      (guix-service-type
       config => (guix-configuration
                   (inherit config)
                   (authorized-keys
                    (cons* (local-file
                            (format #f "~a/nonguix.pub" %guix-dots-dir))
                           %default-authorized-guix-keys))
                   (substitute-urls
                    (cons* "https://substitutes.nonguix.org"
                           %default-substitute-urls))))))))
