(define-module (mrh-guix system om networking)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (guix gexp)
  #:use-module (gnu services containers)
  #:use-module (gnu services dns)
  #:use-module (gnu services networking))

(define-public %wireguard-ipv4 (format #f "~a.1" %wireguard-ipv4-prefix))
(define-public %lan-ipv4 (format #f "~a.171" %lan-ipv4-prefix))

(define-public %wpa-supplicant-config
  (wpa-supplicant-configuration
    (interface %wlan-interface)
    (config-file (local-file "wpa-supplicant.conf"))))

(define-public %nftables-config
  (nftables-configuration
    (ruleset (local-file "nftables.conf"))))

(define dns-interfaces (list "127.0.0.1" %wireguard-ipv4 %lan-ipv4))
(define dns-servers '("9.9.9.9" "2620:fe::9"
                      "1.1.1.1" "2606:4700:4700::1111"))

(define-public %dnsmasq-config
  (dnsmasq-configuration
    (listen-addresses dns-interfaces)
    (servers dns-servers)
    (cache-size 5000)
    (no-hosts? #f)
    (query-servers-in-order? #t)
    (addresses
     (list (format #f "/home.~a/~a" %domain-name %wireguard-ipv4)))
    (extra-options '("--filterwin2k"))))

(define-public %dhcpd-config
  (dhcpcd-configuration
    (static
     (list (format #f "domain_name_servers=127.0.0.1 ~a ~a"
                   %wireguard-ipv4
                   %lan-ipv4)))))

(define-public %unbound-config
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

local-zone: \"home.~a.\" static
local-data: \"home.~a. IN A 10.0.0.1\"
local-data-ptr: \"10.0.0.1 home.~a\"

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
             %domain-name))))

(define-public %adguard-config
  (oci-container-configuration
    (image "adguard/adguardhome")
    (provision "adguard")
    (network "host")
    (ports (list (format #f "~a:53:53" %wireguard-ipv4)
                 (format #f "~a:853:853" %wireguard-ipv4)
                 (format #f "~a:3000:3000" %wireguard-ipv4)
                 (format #f "~a:3001:3001" %wireguard-ipv4)))
    (volumes
     '(("adguard-work" . "/opt/adguardhome/work")
       ("adguard-conf" . "/opt/adguardhome/conf")))))
