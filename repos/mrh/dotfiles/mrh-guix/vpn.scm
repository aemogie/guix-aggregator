(define-module (mrh-guix vpn)
  #:use-module (mrh-guix personal)
  #:use-module (gnu)
  #:use-module (gnu services vpn))

(define-public %wireguard-port 51820)

(define-public %local-ipv4-prefix "192.168.1")
(define-public %local-ipv6-prefix "2600:4040:452c:5800")

(define-public %wireguard-ipv4-prefix "10.0.0")
(define-public %wireguard-ipv6-prefix "fd4e:bd3e:79e9")

(define-public (wireguard-client-config num)
  (wireguard-configuration
    (addresses (list (format #f "~a.~a" %wireguard-ipv4-prefix num)
                     (format #f "~a::~a" %wireguard-ipv6-prefix num)))
    (dns (list (format #f "~a.1" %local-ipv4-prefix)
               (format #f "~a::1" %local-ipv6-prefix)))
    (peers (list (wireguard-peer
                   (name "om")
                   (endpoint (format #f "~a:~a" %om-domain-name %wireguard-port))
                   (public-key %om-wireguard-key)
                   (allowed-ips '("0.0.0.0/0" "::/0")))))))

(define-public (wireguard-host-config peers)
  (wireguard-configuration
    (addresses (list (format #f "~a.1" %wireguard-ipv4-prefix)
                     (format #f "~a::1" %wireguard-ipv6-prefix)))
    (peers peers)))

(define-public (wireguard-host-peer name num public-key)
  (wireguard-peer
    (name name)
    (public-key public-key)    
    (allowed-ips (list (format #f "~a.~a" %wireguard-ipv4-prefix num)
                       (format #f "~a::~a" %wireguard-ipv6-prefix num)))))
