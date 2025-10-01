(define-module (mrh-guix system om networking)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (guix gexp)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services containers)
  #:use-module (gnu services dns)
  #:use-module (gnu services networking))

(define-public %wpa-supplicant-service
  (service wpa-supplicant-service-type
           (wpa-supplicant-configuration
             (interface %wlan-interface)
             (config-file (local-file "wpa-supplicant.conf")))))

(define-public %nftables-service
  (service nftables-service-type
           (nftables-configuration
             (ruleset (local-file "nftables.conf")))))

(define dns-interfaces (list "::1"
                             %ipv6-ula-om
                             %ipv6-wireguard-host
                             %ipv4-wireguard-host))

(define dns-servers '("2a07:e340::4@853#base.dns.mullvad.net"
                      "2620:fe::9@853#dns.quad9.net"
                      "194.242.2.4@853#base.dns.mullvad.net"
                      "9.9.9.9@853#dns.quad9.net"
                      ))

(define-public %unbound-service
  (service unbound-service-type
           (unbound-configuration
             (server (unbound-server
                       (interface dns-interfaces)
                       (hide-version #t)
                       (hide-identity #t)
                       (tls-cert-bundle "/etc/ssl/certs/ca-certificates.crt")))
             (forward-zone
              (list (unbound-zone
                      (name ".")
                      (forward-addr dns-servers)
                      (forward-tls-upstream #t))))
             ;; can't be in config because of a formatting bug in the guix service
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
access-control: ~a::/48 allow
access-control: ~a.0/8 allow
access-control: ~a::/48 allow
access-control: ~a.0.0/16 allow

private-address: ~a::/48
private-address: ~a.0/8
private-address: ~a::/48
private-address: ~a.0.0/16

local-zone: \"~a\" static
local-data: \"~a IN AAAA ~a::1\"

local-zone: \"om\" static
local-data: \"om IN AAAA ~a\"

local-zone: \"sleep\" static
local-data: \"sleep IN AAAA ~a\"

local-zone: \"home.~a\" redirect
local-data: \"home.~a 86400 IN AAAA ~a\"
local-data: \"home.~a 86400 IN A ~a\"
"
                                    %ipv6-wireguard-prefix
                                    %ipv4-wireguard-prefix
                                    %ipv6-ula-prefix
                                    %ipv4-lan-prefix

                                    %ipv6-wireguard-prefix
                                    %ipv4-wireguard-prefix
                                    %ipv6-ula-prefix
                                    %ipv4-lan-prefix

                                    %router-domain-name
                                    %router-domain-name
                                    %ipv6-gua-prefix

                                    %ipv6-ula-om

                                    %ipv6-ula-sleep

                                    %domain-name
                                    %domain-name %ipv6-wireguard-host
                                    %domain-name %ipv4-wireguard-host
                                    )))))

(define-public %dhcpcd-service
  (service dhcpcd-service-type
           (dhcpcd-configuration
             (interfaces (list %wlan-interface))
             (static
              (list (format #f "ip6_address=~a/64" %ipv6-ula-om)
                    (format #f "domain_name_servers=::1 ~a ~a ~a"
                            %ipv6-ula-om
                            %ipv6-wireguard-host
                            %ipv4-wireguard-host))))))

(define-public %dnsmasq-service
  (service dnsmasq-service-type
           (dnsmasq-configuration
             (listen-addresses dns-interfaces)
             (servers dns-servers)
             (cache-size 5000)
             (no-hosts? #t)
             (no-resolv? #t)
             (query-servers-in-order? #t)
             (addresses
              (list (format #f "/~a/~a::1" %router-domain-name %ipv6-gua-prefix)
                    (format #f "/om/~a" %ipv6-ula-om)
                    (format #f "/sleep/~a" %ipv6-ula-sleep)))
             (extra-options '("--filterwin2k")))))

(define-public %adguard-config
  (oci-container-configuration
    (image "adguard/adguardhome")
    (provision "adguard")
    (network "host")
    (ports '("[::1]:53:53"
             "[::1]:853:853"
             "[::1]:3000:3000"
             "[::1]:3001:3001"))
    (volumes
     '(("adguard-work" . "/opt/adguardhome/work")
       ("adguard-conf" . "/opt/adguardhome/conf")))))
