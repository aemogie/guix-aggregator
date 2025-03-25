(define-module (mrh-guix vpn)
  #:use-module (mrh-guix personal)
  
  #:use-module (gnu)
  
  #:use-module (gnu services vpn))

(define-public (wireguard-client-config num)
  (wireguard-configuration
   (addresses (list (format #f "10.0.0.~a/32" num)
                    (format #f "fd4e:bd3e:79e9::~a/64" num)))
   (port 51820)
   (dns '("192.168.1.1" "2600:4040:452f:cd00::1"))
   (peers (list (wireguard-peer
                 (name "guix-box")
                 (endpoint (format #f "~a:51820" %box-domain-name))
                 (public-key %box-public-key)
                 (allowed-ips '("0.0.0.0/0" "::/0")))))))

(define-public (wireguard-host-peer name num public-key)
  (wireguard-peer
   (name name)
   (public-key public-key)
   (allowed-ips (list (format #f "10.0.0.~a/32" num)
                      (format #f "fd4e:bd3e:79e9::~a/64" num)))))

(define-public (wireguard-host-config peers)
  (wireguard-configuration
   (addresses (list "10.0.0.1/32" "fd4e:bd3e:79e9::1/64"))
   (port 51820)
   (peers peers)))
