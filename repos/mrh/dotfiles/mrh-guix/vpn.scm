(define-module (mrh-guix vpn)
  #:use-module (mrh-guix personal)
  #:use-module (gnu)
  #:use-module (gnu services vpn))

(define-public %wireguard-port 31337)

(define-public %wireguard-ipv6-prefix "fd4e:bd3e:79e9")
(define-public %wireguard-ipv6-host (format #f "~a::1" %wireguard-ipv6-prefix))

(define-public %wireguard-ipv4-prefix "10.0.0")
(define-public %wireguard-ipv4-host (format #f "~a.1" %wireguard-ipv4-prefix))

(define-public (wireguard-client-config num)
  (wireguard-configuration
    (addresses
     (list (format #f "~a::~a" %wireguard-ipv6-prefix num)
           (format #f "~a.~a" %wireguard-ipv4-prefix num)))
    (port %wireguard-port)
    (peers
     (list (wireguard-peer
             (name "om")
             (endpoint (format #f "pub.~a:~a" %domain-name %wireguard-port))
             (public-key %om-wireguard-key)
             (allowed-ips '("::/0" "0.0.0.0/0")))))
    (dns (list %wireguard-ipv6-host %wireguard-ipv4-host))))

(define-public (wireguard-host-config peers)
  (wireguard-configuration
    (addresses (list %wireguard-ipv6-host %wireguard-ipv4-host))
    (port %wireguard-port)
    (peers peers)))

(define-public (wireguard-host-peer name num public-key)
  (wireguard-peer
    (name name)
    (public-key public-key)    
    (allowed-ips
     (list (format #f "~a::~a" %wireguard-ipv6-prefix num)
           (format #f "~a.~a" %wireguard-ipv4-prefix num)))))
