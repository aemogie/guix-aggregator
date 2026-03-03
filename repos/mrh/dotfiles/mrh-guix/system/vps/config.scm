(define-module (mrh-guix system vps config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix services)
  #:use-module (mrh-guix web)
  #:use-module (mrh services)
  #:use-module (gnu)
  #:use-module (gnu services security)
  #:use-module (gnu services certbot)
  #:use-module (gnu services containers)
  #:use-module (gnu services desktop)
  #:use-module (gnu services docker)
  #:use-module (gnu services messaging)
  #:use-module (gnu services networking)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services ssh)
  #:use-module (gnu services sysctl)
  #:use-module (gnu services vpn)
  #:use-module (gnu services web)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages golang-crypto)
  #:use-module (gnu packages i2p)
  #:use-module (gnu packages messaging)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages rsync))

(define restart-when-oom-timer
  (shepherd-service
    (provision '(restart-when-oom))
    (modules '((shepherd service timer)))
    (start #~(make-timer-constructor
              (calendar-event #:minutes '(0))
              (lambda ()
                (let ((mem-available
                       (string->number
                        (car
                         (string-split
                          (string-trim
                           (cadar
                            (filter
                             (lambda (strings)
                               (string= (car strings) "MemAvailable"))
                             (map
                              (lambda (string)
                                (string-split string #\:))
                              (string-split
                               (get-string-all (open-input-file "/proc/meminfo"))
                               #\newline)))))
                          #\space)))))
                  (if (< mem-available 50000)
                      (system "reboot")
                      (format #t "not restarting, available memory is: ~A~%"
                              mem-available))))))
    (stop #~(make-timer-destructor))
    (actions (list shepherd-trigger-action))))

(define-public %vps-operating-system
  (operating-system
    (locale "en_US.utf8")
    (timezone "UTC")
    (keyboard-layout (keyboard-layout "us"))
    (host-name "vps")

    (bootloader
      (bootloader-configuration
        (bootloader grub-bootloader)
        (targets '("/dev/sda"))
        (keyboard-layout keyboard-layout)))

    (initrd-modules
     (cons "virtio_scsi" %base-initrd-modules))

    (file-systems
     (cons (file-system
             (mount-point "/")
             ;; As of 2022-08-28 OVH vps don't have a bios boot partition anymore
             ;; but support is needed for VPSs created before this date
             (device
              (if (access? "/dev/sda2" F_OK)
                  "/dev/sda2"
                  "/dev/sda1"))
             (type "ext4"))
           %base-file-systems))

    (users
     (cons (user-account
             (name %username)
             (group "users")
             (supplementary-groups '("docker"
                                     "input"
                                     "netdev"
                                     "wheel"))
             (home-directory %user-home))
           %base-user-accounts))

    (packages
     (cons* btop
            certbot
            rsync
            stow
            %base-packages))

    (services
     (cons*
      (service
       static-networking-service-type
       (list (static-networking
               (addresses
                (list (network-address
                        (device "eth0")
                        (value (format #f "~a::1138/64" %ipv6-vps-prefix)))
                      (network-address
                        (device "eth0")
                        (value (format #f "~a.49/24" %ipv4-vps-prefix)))))
               (routes
                (list (network-route
                        (device "eth0")
                        (destination "default")
                        (gateway (format #f "~a::1" %ipv6-vps-prefix)))
                      (network-route
                        (device "eth0")
                        (destination "default")
                        (gateway (format #f "~a.1" %ipv4-vps-prefix))))))))

      (service
       nftables-service-type
       (nftables-configuration
         (ruleset (local-file "nftables.conf"))))

      (service
       openssh-service-type
       (openssh-configuration
         (port-number %ssh-port)
         (password-authentication? #f)
         (permit-root-login 'prohibit-password)
         (authorized-keys
          `((,%username ,(plain-file (format #f "ssh-~a.pub" %username)
                                     %ssh-pub))
            ("root" ,(plain-file "ssh-root.pub"
                                 %ssh-pub))))))

      (service
       wireguard-service-type
       (wireguard-configuration
         (addresses
          (list %ipv6-wireguard-vps
                %ipv4-wireguard-vps))
         (port %wireguard-port)
         (peers
          (list (wireguard-peer
                  (name "om")
                  (endpoint (format #f "[~a]:~a" %ipv6-gua-om %wireguard-port))
                  (public-key %om-wireguard-key)
                  (allowed-ips
                   (list %ipv6-wireguard-om
                         %ipv4-wireguard-om)))

                (wireguard-peer
                  (name "sleep")
                  (public-key %sleep-wireguard-key)
                  (allowed-ips
                   (list %ipv6-wireguard-sleep
                         %ipv4-wireguard-sleep)))

                (wireguard-peer
                  (name "lamb")
                  (public-key %lamb-wireguard-key)
                  (allowed-ips
                   (list %ipv6-wireguard-lamb
                         %ipv4-wireguard-lamb)))))
         (dns
          (list %ipv6-wireguard-vps
                %ipv4-wireguard-vps))))

      ;; needed for oci-service
      (service
       elogind-service-type)
      (service
       containerd-service-type)
      (service
       docker-service-type)

      (simple-service
       'oci-provisioning
       oci-service-type
       (oci-extension
        (containers
         (list (oci-container-configuration
                 (image "technitium/dns-server")
                 (provision "dns")
                 (ports (list (format #f "[~a]:5380:5380/tcp" %ipv6-wireguard-vps)
                              (format #f "[~a]:53:53/tcp" %ipv6-wireguard-vps)
                              (format #f "[~a]:53:53/udp" %ipv6-wireguard-vps)

                              (format #f "[~a]:5380:5380/tcp" %ipv4-wireguard-vps)
                              (format #f "[~a]:53:53/tcp" %ipv4-wireguard-vps)
                              (format #f "[~a]:53:53/udp" %ipv4-wireguard-vps)
                              ;; "853:853/udp"
                              ))
                 (environment
                  `(("DNS_SERVER_ADMIN_PASSWORD" . ,%technitium-password)
                    ("DNS_SERVER_PREFER_IPV6" . "true")
                    ("DNS_SERVER_LOG_USING_LOCAL_TIME" . "false")))
                 (volumes
                  '(("technitium-dns-config" . "/etc/dns"))))))))

      (service prosody-service-type
               (prosody-configuration
                 (plugin-paths (list prosody-cloud-notify
                                     prosody-vcard-muc))
                 (modules-enabled
                  (cons* "bookmarks"
                         "bosh"
                         "csi"
                         "csi_simple"
                         "cloud_notify"
                         "groups"
                         "invites_adhoc"
                         "invites_register"
                         "mam"
                         "pubsub"
                         "s2s_bidi"
                         "smacks"
                         "vcard_legacy"
                         "websocket"
                         %default-modules-enabled))
                 (modules-disabled '("vcard"))
                 (int-components
                  (list
                   (int-component-configuration
                     (plugin "muc")
                     (hostname (format #f "group.~a" %domain-name))
                     (modules-enabled '("muc_mam"
                                        "vcard_muc"))
                     (mod-muc (mod-muc-configuration
                                (name "wumpus groups")
                                (restrict-room-creation "local"))))
                   (int-component-configuration
                     (plugin "http_file_share")
                     (hostname (format #f "share.~a" %domain-name)))
                   (int-component-configuration
                     (plugin "proxy65")
                     (hostname (format #f "proxy.~a" %domain-name)))))
                 (virtualhosts
                  (list
                   (virtualhost-configuration
                     (domain %domain-name))))
                 (admins
                  (list (format #f "~a@~a" %username %domain-name)))
                 (raw-content "legacy_ssl_ports = { 5223; 5270 }\n")))

      (service
       nginx-service-type
       (let ((certs-path (format #f "/etc/letsencrypt/live/~a" %domain-name))
             (proxy-headers '("proxy_set_header Host $host;"
                              "proxy_set_header X-Real-IP $remote_addr;"
                              "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                              "proxy_set_header X-Forwarded-Proto $scheme;"
                              "proxy_set_header X-Forwarded-Protocol $scheme;"
                              "proxy_set_header X-Forwarded-Host $http_host;"
                              "proxy_buffering off;")))
         (nginx-configuration
           (shepherd-requirement '(wireguard-wg0))
           (server-blocks
            (list
             (nginx-server-configuration
               (listen '("[::]:80" "80"
                         "[::]:443 ssl" "443 ssl"))
               (server-name (list  %domain-name))
               (root (format #f "/srv/http/~a" %domain-name))
               (ssl-certificate (format #f "~a/fullchain.pem" certs-path))
               (ssl-certificate-key (format #f "~a/privkey.pem" certs-path)))

             (nginx-server-configuration
               (listen '("[::]:80" "80"
                         "[::]:443 ssl" "443 ssl"))
               (server-name
                (list  %old-domain-name
                       (format #f "*.~a" %old-domain-name)))
               (locations
                (list
                 (nginx-location-configuration
                   (uri "/")
                   (body
                    (list (format #f "return 301 $scheme://~a$request_uri;"
                                  %domain-name))))
                 (nginx-location-configuration
                   (uri "/blog")
                   (body
                    (list (format #f "return 301 $scheme://~a/posts;"
                                  %domain-name)))))))

             (app-server-block
              "i2p.remote" %ipv6-wireguard-vps "::1"
              #:port 7070)

             (app-server-block
              "upload" "::" "::1"
              #:port 5281
              #:certs-path certs-path
              #:extra proxy-headers))))))

      (service
       yggdrasil-service-type
       (yggdrasil-configuration
         (config-file
          (format #f "~a/.config/yggdrasil/yggdrasil-private.conf" %user-home))
         (json-config
          '((listen . #("tcp://[::]:31341"))
            (peers . #("tcp://marisa.nadeko.net:44441"
                       "tls://ygg.jjolly.dev:3443"))))))

      (service
       i2pd-service-type
       (i2pd-configuration
        (i2pd (symlink-to
               "/gnu/store/h0a0z01j87azzr61bfc1z9w5lyaqw5p2-i2pd-2.58.0"))
        (user %username)
        (conf (format #f "~a/.config/i2pd/i2pd.conf" %user-home))
        (datadir (format #f "~a/.config/i2pd" %user-home))))

      (service
       tor-service-type
       (tor-configuration
         (config-file (local-file (format #f "~a/.config/torrc" %user-home)))
         (hidden-services
          (list (tor-onion-service-configuration
                  (name "wumpus.life")
                  (mapping '((80 "[::1]:80"))))))
         ;; (transport-plugins
         ;;  (list (tor-transport-plugin
         ;;          (role 'server)
         ;;          (program (file-append go-obfs4proxy "/bin/obfs4proxy")))))
         ))

      (service
       pounce-service-type
       (pounce-configuration
         (local-host %ipv6-wireguard-vps)
         (host "irc.libera.chat")
         (client-cert "/etc/pounce/libera.pem")
         (nick %irc-nick)
         (join (list "#guix" "#yggdrasil"))))

      (simple-service
       'my-timers
       shepherd-root-service-type
       (list restart-when-oom-timer))

      (modify-services %base-services
        (guix-service-type
         config => (guix-configuration
                     (inherit config)
                     (authorized-keys
                      (cons*
                       (local-file (format #f "~a/sleep-guix.pub" %guix-dots-dir))
                       (local-file (format #f "~a/vps-guix.pub" %guix-dots-dir))
                       %default-authorized-guix-keys))))

        (sysctl-service-type
         config => (sysctl-configuration
                     (settings
                      (append '(("net.ipv6.conf.all.forwarding" . "1")
                                ("net.ipv4.ip_forward" . "1"))
                              %default-sysctl-settings)))))))))

%vps-operating-system
