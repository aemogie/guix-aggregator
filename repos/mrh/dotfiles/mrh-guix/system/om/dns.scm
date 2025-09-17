(define-module (mrh-guix system om dns)
  #:use-module (mrh-guix personal)
  #:use-module (gnu services dns))

(define interfaces '("10.0.0.1" "127.0.0.1"))
(define dns-servers '("9.9.9.9" "2620:fe::9"
                      "1.1.1.1" "2606:4700:4700::1111"
                      "8.8.8.8"
                      "149.112.112.112"))

(define-public %dnsmasq-config
  (dnsmasq-configuration
    (listen-addresses interfaces)
    (servers dns-servers)
    (cache-size 5000)
    (no-hosts? #f)
    (query-servers-in-order? #f)
    (addresses (list (format #f "/home.~a/10.0.0.1" %domain-name)))))

(define-public %unbound-config
  (unbound-configuration
    (server
     (unbound-server
       (interface interfaces)
       (hide-version #t)
       (hide-identity #t)
       (extra-options '((aggressive-nsec . yes)
                        (cache-max-ttl . 14400)
                        (cache-min-ttl . 1200)
                        (prefetch . yes)
                        (rrset-roundrobin . yes)
                        (so-reuseport . yes)
                        (use-caps-for-id . yes)
                        (serve-expired . yes)
                        (do-daemonize . yes)
                        (msg-cache-size  . 8)
                        (rrset-cache-size . 16)
                        (verbosity . 1)))))
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

local-zone: home.~a. static
local-data: \"home.~a. IN A 10.0.0.1\"
local-data-ptr: \"10.0.0.1 home.~a\""
             %domain-name
             %domain-name
             %domain-name))))
