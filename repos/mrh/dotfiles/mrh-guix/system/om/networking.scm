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

(define dns-servers '("2620:fe::9" "2620:fe::11"
                      "2606:4700:4700::1111" "2606:4700:4700::1112"))

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
              (list (format #f "/mynetworksettings.com/~a::1" %ipv6-gua-prefix)
                    (format #f "/om/~a" %ipv6-ula-om)
                    (format #f "/sleep/~a" %ipv6-ula-sleep)))
             (extra-options '("--filterwin2k")))))

(define-public %dhcpcd-service
  (service dhcpcd-service-type
           (dhcpcd-configuration
             (interfaces (list %wlan-interface))
             (static
              (list (format #f "ip6_address=~a/64" %ipv6-ula-om)
                    (format #f "domain_name_servers=::1 ~a ~a"
                            %ipv6-wireguard-host
                            %ipv6-ula-om))))))

(define-public %unbound-service
  (service unbound-service-type
           (unbound-configuration
             (server
              (unbound-server
                (interface dns-interfaces)))
             (forward-zone
              (list (unbound-zone
                      (name ".")
                      (forward-addr dns-servers))))
             (extra-content
              (format #f "
server:
access-control: 10.0.0.0/8 allow
access-control: 127.0.0.0/8 allow
access-control: 192.168.0.0/16 allow

private-address: 192.168.0.0/16
private-address: 10.0.0.0/8

local-zone: \"priv.~a.\" static
local-data: \"priv.~a. IN A 10.0.0.1\"
local-data-ptr: \"10.0.0.1 priv.~a\"

interface-automatic: yes

cache-max-ttl: 14400
cache-min-ttl: 1200

aggressive-nsec: yes
hide-identity: yes
hide-version: yes

prefetch: yes
rrset-roundrobin: yes

so-reuseport: yes
use-caps-for-id: yes

# Unbound from pkg built with libevent; increase threads and slabs to the
# number of real cpu cores to reduce lock contention. Increase cache size to
# store more records and allow each thread to serve an increased number of
# concurrent client requests.
num-threads: 4
msg-cache-slabs: 4
rrset-cache-slabs: 4
infra-cache-slabs: 4
key-cache-slabs: 4
msg-cache-size: 256M
rrset-cache-size: 512M
outgoing-range: 8192
num-queries-per-thread: 4096
"
                      %domain-name
                      %domain-name
                      %domain-name)))))

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
