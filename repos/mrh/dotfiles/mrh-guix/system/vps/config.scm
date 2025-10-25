(define-module (mrh-guix system vps config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (beaver system)
  #:use-module (beaver functional-services)
  #:use-module (gnu)
  #:use-module (gnu services certbot)
  #:use-module (gnu services networking)
  #:use-module (gnu services vpn)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages rsync))

(let ((certs-path (format #f "/etc/certs/~a" %domain-name)))
  (-> (minimal-ovh %ssh-pub)

      (os/hostname "vps")

      (packages btop rsync)

      (add-service nftables
                   (ruleset (local-file "nftables.conf")))

      (add-service wireguard
                   (addresses
                    (list (format #f "~a::4" %ipv6-wireguard-prefix)
                          (format #f "~a.4" %ipv4-wireguard-prefix)))
                   (port %wireguard-port)
                   (peers
                    (list (wireguard-peer
                            (name "om")
                            (endpoint
                             (format #f "pub.~a:~a" %domain-name %wireguard-port))
                            (public-key %om-wireguard-key)
                            (allowed-ips
                             (list
                              (format #f "~a::/64" %ipv6-wireguard-prefix)
                              (format #f "~a.0/24" %ipv4-wireguard-prefix))))))
                   (dns
                    (list (format #f "~a::1" %ipv6-wireguard-prefix)
                          (format #f "~a.1" %ipv4-wireguard-prefix))))

      (add-service certbot
                   (email %email)
                   (certificates
                    (list (certificate-configuration
                           (domains (map (lambda (fstring)
                                           (format #f fstring %domain-name))
                                         (list "~a"
                                               "www.~a"
                                               "home.~a"
                                               "*.home.~a"
                                               "pub.~a"
                                               "*.pub.~a")))))))

      (httpx-reverse-proxy
       #:from-host (format #f "www.~a" %domain-name)
       #:to-port 8080
       #:fullchain-path (format #f "~a/fullchain.pem" certs-path)
       #:privkey-path (format #f "~a/privkey.pem" certs-path))

      (httpx-reverse-proxy
       #:from-host %domain-name
       #:to-port 8081
       #:fullchain-path (format #f "~a/fullchain.pem" certs-path)
       #:privkey-path (format #f "~a/privkey.pem" certs-path))

      (http-static-content
       #:from-host "localhost"
       #:from-port 8081
       #:to-dir (format #f "/var/www/~a" %domain-name))))
