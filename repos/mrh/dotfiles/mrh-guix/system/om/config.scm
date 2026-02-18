(define-module (mrh-guix system om config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh services)
  #:use-module (mrh-guix web)
  #:use-module (mrh-guix system om oci-containers)
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

(define-public %om-operating-system
  (operating-system
    (kernel linux)
    (firmware (list linux-firmware))
    (initrd microcode-initrd)
    (host-name "om")
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
             (target (uuid "23c6c6c3-3653-4eed-95fa-cee1b87acc32")))))

    (file-systems
     (cons* (file-system
              (mount-point "/boot/efi")
              (device (uuid "1921-C31A" 'fat32))
              (type "vfat"))
            (file-system
              (mount-point "/")
              (device
               (uuid "6ec680cc-bf14-49d2-b4d0-d4feac003ae1" 'ext4))
              (type "ext4"))
            (file-system
              (mount-point "/mnt/wd")
              (device
               (uuid "5781ea1d-72c6-4dd7-9af0-9442a0502fc4" 'ext4))
              (type "ext4"))
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
                     (list isc-bind "utils")
                     openssl
                     rsync
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
                        (device %om-wlan-interface)
                        (value (format #f "~a/64" %ipv6-ula-om)))
                      (network-address
                        (device %om-wlan-interface)
                        (value (format #f "~a/64" %ipv6-gua-om)))
                      (network-address
                        (device %om-wlan-interface)
                        (value (format #f "~a/24" %ipv4-lan-om)))))
               (routes
                (list (network-route
                        (device %om-wlan-interface)
                        (destination "default")
                        (gateway %ipv6-lan-gateway))
                      (network-route
                        (device %om-wlan-interface)
                        (destination "default")
                        (gateway %ipv4-lan-gateway))))
               (name-servers
                (list %ipv6-wireguard-vps
                      %ipv4-wireguard-vps
                      "2620:fe::9"
                      "9.9.9.9")))))

      (service
       wpa-supplicant-service-type
       (wpa-supplicant-configuration
         (interface %om-wlan-interface)
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
          (list %ipv6-wireguard-om
                %ipv4-wireguard-om))
         (port %wireguard-port)
         (peers
          (list (wireguard-peer
                  (name "vps")
                  (endpoint (format #f "~a:~a" %domain-name %wireguard-port))
                  (public-key %vps-wireguard-key)
                  (allowed-ips
                   (list (format #f "~a::/64" %ipv6-wireguard-prefix)
                         (format #f "~a.0/24" %ipv4-wireguard-prefix))))

                ;; (wireguard-peer
                ;;   (name "sleep")
                ;;   (public-key %sleep-wireguard-key)
                ;;   (allowed-ips
                ;;    (list %ipv6-wireguard-sleep
                ;;          %ipv4-wireguard-sleep)))
                ))))

      (service
       yggdrasil-service-type
       (yggdrasil-configuration
         (config-file
          (format #f "~a/.config/yggdrasil/yggdrasil-private.conf" %user-home))
         (json-config
          '((peers . #("tcp://ygg-us-ny.nadeko.net:44441"
                       "tls://ygg.jjolly.dev:3443"))))))

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
             (let ((sleep (syncthing-device
                            (name "sleep")
                            (id %sleep-syncthing-id)))
                   (lamb (syncthing-device
                           (name "lamb")
                           (id %lamb-syncthing-id))))
               (list (syncthing-folder
                       (id "default")
                       (label "default")
                       (path "~/sync")
                       (devices (list sleep lamb)))
                     (syncthing-folder
                       (id "paperless-upload")
                       (label "paperless-upload")
                       (path (format #f "~a/data/paperless" %user-home))
                       (devices (list sleep lamb))))))))))

      ;; required for oci-service-type
      (service
       containerd-service-type)
      (service
       docker-service-type
       (docker-configuration
         (config-file (local-file "dockerd.json" "dockerd-json"))))

      (simple-service
       'oci-provisioning
       oci-service-type
       (oci-extension
        (networks
         (list (oci-network-configuration
                (name "media"))
               (oci-network-configuration
                (name "paperless"))))
        (containers
         (append %sabnzbd-oci
                 %sonarr-oci
                 %jellyfin-oci
                 %paperless-oci
                 %homepage-oci))))

      (service
       nginx-service-type
       (nginx-configuration
         (shepherd-requirement '(wireguard-wg0))
         (server-blocks
          (let ((local-app-server-block
                 (lambda* (name port #:key (additional-names '()) (extra '()))
                   (app-server-block name %ipv6-wireguard-om "::1"
                                     #:port port
                                     #:additional-names additional-names
                                     #:extra extra))))
            (list (root-server-block "lan" %ipv6-wireguard-om)
                  (root-server-block "sec" %ipv6-wireguard-om)
                  (local-app-server-block
                   "homepage.sec" 3000)
                  (local-app-server-block
                   "sync.sec" 8384)
                  (local-app-server-block
                   "paper.sec" 8000)
                  (local-app-server-block
                   "sab.sec" 8081)
                  (local-app-server-block
                   "sonarr.sec" 8989)
                  (local-app-server-block
                   "jelly.sec" 8096
                   #:additional-names '("jelly")
                   #:extra
                   '("proxy_set_header Host $host;"
                     "proxy_set_header X-Real-IP $remote_addr;"
                     "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                     "proxy_set_header X-Forwarded-Proto $scheme;"
                     "proxy_set_header X-Forwarded-Protocol $scheme;"
                     "proxy_set_header X-Forwarded-Host $http_host;"
                     "proxy_buffering off;")))))))

      (modify-services %base-services
        (guix-service-type
         config => (guix-configuration
                     (inherit config)
                     (authorized-keys
                      (cons (local-file
                             (format #f "~a/nonguix.pub" %guix-dots-dir))
                            %default-authorized-guix-keys))
                     (substitute-urls
                      (cons "https://substitutes.nonguix.org"
                            %default-substitute-urls))))

        (sysctl-service-type
         config => (sysctl-configuration
                     (settings
                      (append '(("net.ipv6.conf.all.forwarding" . "1")
                                ("net.ipv4.ip_forward" . "1"))
                              %default-sysctl-settings)))))))))

%om-operating-system
