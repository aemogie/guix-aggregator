(define-module (mrh-guix system vps config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix services)
  #:use-module (mrh-guix web)
  #:use-module (mrh services)
  #:use-module (gnu)
  #:use-module (gnu services security)
  #:use-module (gnu services certbot)
  #:use-module (gnu services dns)
  #:use-module (gnu services networking)
  #:use-module (gnu services ssh)
  #:use-module (gnu services sysctl)
  #:use-module (gnu services vpn)
  #:use-module (gnu services web)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages i2p)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages rsync))

(define-public %vps-operating-system
  (operating-system
    (locale "en_US.utf8")
    (timezone "UTC")
    (keyboard-layout (keyboard-layout "fr"))
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

    (groups
     (cons (user-group (name "docker"))
           %base-groups))

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
                        (value "2607:5300:205:200::1138/64"))
                      (network-address
                        (device "eth0")
                        (value "51.222.9.49/24"))))
               (routes
                (list (network-route
                        (device "eth0")
                        (destination "default")
                        (gateway "2607:5300:205:200::1"))
                      (network-route
                        (device "eth0")
                        (destination "default")
                        (gateway "51.222.9.1")))))))

      (service
       nftables-service-type
       (nftables-configuration
         (ruleset (local-file "nftables.conf"))))

      (service
       unbound-after-wg-service-type
       (unbound-configuration
         (server
          (unbound-server
            (interface
             (list "::1"
                   %ipv6-wireguard-vps
                   "127.0.0.1"
                   %ipv4-wireguard-vps))
            (hide-version #t)
            (hide-identity #t)
            (tls-cert-bundle "/etc/ssl/certs/ca-certificates.crt")))
         ;; can't be in config because of a formatting bug in the service definition
         (extra-content (format #f "
server:
aggressive-nsec: yes
do-ip4: yes
do-ip6: yes
do-tcp: yes
prefetch: yes
rrset-roundrobin: yes
so-reuseport: yes
use-caps-for-id: yes

access-control: ::1/128 allow
access-control: 127.0.0.1/32 allow
access-control: ~a::/64 allow
access-control: ~a.0/24 allow

private-address: ~a::/64
private-address: ~a.0/24

local-zone: \"~a\" static
local-data: \"~a IN AAAA ~a::1\"

local-zone: \"om\" static
local-data: \"om IN AAAA ~a\"

local-zone: \"sleep\" static
local-data: \"sleep IN AAAA ~a\"

local-zone: \"home.~a\" redirect
local-data: \"home.~a 86400 IN AAAA ~a\"

local-zone: \"i2p.pub.~a\" redirect
local-data: \"i2p.pub.~a 86400 IN AAAA ~a\"
"
                                %ipv6-wireguard-prefix
                                %ipv4-wireguard-prefix

                                %ipv6-wireguard-prefix
                                %ipv4-wireguard-prefix

                                %router-domain-name
                                %router-domain-name %ipv6-gua-prefix

                                %ipv6-wireguard-om

                                %ipv6-wireguard-sleep

                                %domain-name
                                %domain-name %ipv6-wireguard-om

                                %domain-name
                                %domain-name %ipv6-wireguard-vps
                                ))))

      (service
       openssh-service-type
       (openssh-configuration
         (permit-root-login 'prohibit-password)
         (password-authentication? #f)
         (authorized-keys
          `((,%username ,(plain-file (format #f "ssh-~a.pub" %username)
                                     %ssh-pub))))))

      (service
       fail2ban-service-type
       (fail2ban-configuration
         (extra-jails
          (list (fail2ban-jail-configuration
                  (name "sshd")
                  (enabled? #t)
                  (max-retry 3)
                  (find-time "1d")
                  (ban-time "1w")
                  (ban-time-increment? #t)
                  (ban-time-factor "2")
                  (ban-time-max-time "1mo")
                  (ban-time-overall-jails? #t)
                  (ignore-self? #t)
                  (ignore-ip
                   (list (format #f "~a::/64" %ipv6-wireguard-prefix)
                         (format #f "~a.0/24" %ipv4-wireguard-prefix)
                         %ipv6-gua-om
                         %ipv4-home)))))))

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

      (service
       yggdrasil-service-type
       (yggdrasil-configuration
         (config-file
          (format #f "~a/.config/yggdrasil/yggdrasil-private.conf" %user-home))
         (json-config
          '((listen . #("tcp://[::]:31341"))
            (peers . #("tcp://ygg-us-ny.nadeko.net:44441"
                       "tls://ygg.jjolly.dev:3443"))))))

      (service
       i2pd-service-type
       (i2pd-configuration
        (i2pd i2pd)
        (user %username)
        (conf (format #f "~a/.config/i2pd/i2pd.conf" %user-home))
        (datadir (format #f "~a/.config/i2pd" %user-home))))

      (service
       tor-service-type
       (tor-configuration
         (auto-start? #f)
         (config-file (local-file (format #f "~a/.config/torrc" %user-home)))
         (hidden-services
          (list (tor-onion-service-configuration
                  (name "wumpus.life")
                  (mapping '((80 "[::1]:80"))))))))

      (service
       certbot-service-type
       (certbot-configuration
         (email %email)
         (certificates
          (list (certificate-configuration
                 (domains (map (lambda (fstring)
                                 (format #f fstring %domain-name))
                               '("~a"
                                 "home.~a"
                                 "*.home.~a"
                                 "pub.~a"
                                 "*.pub.~a"))))))))

      (service
       nginx-service-type
       (let ((certs-path (format #f "/etc/certs/~a" %domain-name)))
         (nginx-configuration
           (shepherd-requirement '(wireguard-wg0))
           (server-blocks
            (list
             (nginx-server-configuration
               (listen '("[::]:80" "80"
                         "[::]:443 ssl" "443 ssl"))
               (server-name
                (list  %domain-name
                       (format #f "pub.~a" %domain-name)))
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
                    (list (format #f "return 301 $scheme://~a/posts$request_uri;"
                                  %domain-name)))))))

             (app-server-block
              "i2p.pub" %ipv6-wireguard-vps 7070)

             (nginx-server-configuration
               (listen '("[::]:443 ssl" "443 ssl"))
               (server-name
                (list (format #f "*.pub.~a" %domain-name)))
               (locations
                (list
                 (nginx-location-configuration
                   (uri "/")
                   (body
                    (list
                     (format #f "proxy_pass http://[~a::1]/;" %ipv6-wireguard-prefix)
                     "proxy_set_header Host $host;"
                     "proxy_set_header X-Real-IP $remote_addr;"
                     "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                     "proxy_set_header X-Forwarded-Proto $scheme;"
                     "proxy_set_header X-Forwarded-Protocol $scheme;"
                     "proxy_set_header X-Forwarded-Host $http_host;"
                     "proxy_buffering off;")))))
               (ssl-certificate
                (format #f "~a/fullchain.pem" certs-path))
               (ssl-certificate-key
                (format #f "~a/privkey.pem" certs-path))))))))

      (modify-services %base-services
        (sysctl-service-type
         config => (sysctl-configuration
                     (settings
                      (append '(("net.ipv6.conf.all.forwarding" . "1")
                                ("net.ipv4.ip_forward" . "1"))
                              %default-sysctl-settings)))))))))

%vps-operating-system
