(define-module (mrh-guix system om config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh services)
  #:use-module (mrh-guix web)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:use-module (gnu)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports))

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
       dnsmasq-service-type
       (dnsmasq-configuration
         (listen-addresses
          (list "::1"
                %ipv6-ula-om
                %ipv6-wireguard-om

                "127.0.0.1"
                %ipv4-lan-om
                %ipv4-wireguard-om))
         (servers
          (list %ipv6-wireguard-vps
                %ipv4-wireguard-vps

                "2620:fe::9"
                "9.9.9.9"))
         (cache-size 5000)
         (no-hosts? #t)
         (no-resolv? #t)
         (query-servers-in-order? #t)
         (addresses
          (list (format #f "/~a/~a::1" %router-domain-name %ipv6-gua-prefix)
                (format #f "/om/~a" %ipv6-ula-om)
                (format #f "/sleep/~a" %ipv6-ula-sleep)
                (format #f "/home.~a/~a" %domain-name %ipv6-wireguard-om)
                (format #f "/i2p.pub.~a/~a" %domain-name %ipv6-wireguard-vps)))
         (extra-options '("--filterwin2k"))))

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
         (password-authentication? #f)))

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
                       (label "default folder")
                       (path "~/sync")
                       (devices (list sleep lamb))))))))))

      (service
       nfs-service-type
       (nfs-configuration
         (exports '(("/mnt/wd"
                     "sleep(rw,sync,insecure,no_root_squash,no_subtree_check)")))))

      ;; required for oci-service-type
      (service
       containerd-service-type)
      (service
       docker-service-type)

      (simple-service
       'oci-provisioning
       oci-service-type
       (oci-extension
        (containers
         (let ((oci-uid (get-line (open-input-pipe "id oci-container -u")))
               (oci-gid (get-line (open-input-pipe "id oci-container -g"))))
           (list (oci-container-configuration
                   (image "linuxserver/sabnzbd")
                   (provision "sabnzbd")
                   (ports '("[::1]:8081:8081"))
                   (environment `(("PUID" . ,oci-uid)
                                  ("PGID" . ,oci-gid)
                                  ("TZ" . "Etc/UTC")))
                   (volumes
                    `((,(format #f "~a/.config/sabnzbd" %user-home) . "/config")
                      ("/mnt/wd/media" . "/media"))))

                 (oci-container-configuration
                   (image "jellyfin/jellyfin")
                   (provision "jellyfin")
                   (ports (list "[::1]:8096:8096"
                                (format #f "~a:8096:8096" %ipv4-lan-om)
                                "[::]:7359:7359"))
                   (environment `(("PUID" . ,oci-uid)
                                  ("PGID" . ,oci-gid)))
                   (volumes '(("jellyfin-config" . "/config")
                              ("jellyfin-cache" . "/cache")
                              ("/mnt/wd/media" . "/media")))))))))

      (let ((listen-address (format #f "~a::1" %ipv6-wireguard-prefix)))
        (service
         nginx-service-type
         (nginx-configuration
           (shepherd-requirement '(wireguard-wg0))
           (server-blocks
            (list (root-server-block "pub" listen-address)
                  (root-server-block "home" listen-address)
                  (app-server-block
                   "syncthing.home" listen-address 8384)
                  (app-server-block
                   "sab.home" listen-address 8081)
                  (app-server-block
                   "jelly.home" listen-address 8096
                   "proxy_set_header Host $host;"
                   "proxy_set_header X-Real-IP $remote_addr;"
                   "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                   "proxy_set_header X-Forwarded-Proto $scheme;"
                   "proxy_set_header X-Forwarded-Protocol $scheme;"
                   "proxy_set_header X-Forwarded-Host $http_host;"
                   "proxy_buffering off;"))))))

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
