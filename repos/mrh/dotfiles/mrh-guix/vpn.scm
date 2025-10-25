(define-module (mrh-guix vpn)
  #:use-module (mrh-guix personal)
  #:use-module (gnu)
  #:use-module (gnu services vpn))

(define-public %wireguard-port 31337)

(define-public %ipv6-wireguard-prefix "fd4e:bd3e:79e9")
(define-public %ipv6-wireguard-host (format #f "~a::1" %ipv6-wireguard-prefix))

(define-public %ipv4-wireguard-prefix "10.0.0")
(define-public %ipv4-wireguard-host (format #f "~a.1" %ipv4-wireguard-prefix))

(define-public (wireguard-client-config num)
  (wireguard-configuration
    (addresses
     (list (format #f "~a::~a" %ipv6-wireguard-prefix num)
           (format #f "~a.~a" %ipv4-wireguard-prefix num)))
    (port %wireguard-port)
    (peers
     (list (wireguard-peer
             (name "om")
             (endpoint (format #f "pub.~a:~a" %domain-name %wireguard-port))
             (public-key %om-wireguard-key)
             (allowed-ips '("::/0" "0.0.0.0/0")))))
    (dns (list %ipv6-wireguard-host
               %ipv4-wireguard-host))))

(define-public (wireguard-host-config peers)
  (wireguard-configuration
    (addresses
     (list %ipv6-wireguard-host
           %ipv4-wireguard-host))
    (port %wireguard-port)
    (peers peers)))

(define-public (wireguard-host-peer name num public-key)
  (wireguard-peer
    (name name)
    (public-key public-key)    
    (allowed-ips
     (list (format #f "~a::~a" %ipv6-wireguard-prefix num)
           (format #f "~a.~a" %ipv4-wireguard-prefix num)))))
