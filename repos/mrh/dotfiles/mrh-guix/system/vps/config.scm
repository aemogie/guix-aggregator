(define-module (mrh-guix system vps config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (beaver system)
  #:use-module (beaver functional-services)
  #:use-module (gnu)
  #:use-module (gnu services certbot)
  #:use-module (gnu services networking)
  #:use-module (gnu services ssh)
  #:use-module (gnu services vpn)
  #:use-module (gnu services web)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages rsync)
  #:use-module (ice-9 match))

(let ((user "mrh")
      (user-groups '("netdev" "input" "wheel" "docker"))
      (ssh-user-file (plain-file "ssh-mrh.pub" %ssh-pub))
      (certs-path (format #f "/etc/certs/~a" %domain-name)))

  (-> (minimal-ovh)

      (groups @ user-groups)

      (users
       (user-account
         (name user)
         (group "users")
         (supplementary-groups user-groups)
         (home-directory (string-append "/home/" user))))

      (add-service openssh
                   (permit-root-login 'prohibit-password)
                   (password-authentication? #f)
                   (authorized-keys
                    `((,user ,ssh-user-file))))

      (os/hostname "vps")

      (packages btop rsync stow)

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
                             (format #f "~a:~a" %ipv4-home %wireguard-port))
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

      (add-service nginx
                   (server-blocks
                    (list (nginx-server-configuration
                            (server-name
                             (list  %domain-name
                                    (format #f "www.~a" %domain-name)))
                            (root (format #f "/var/www/~a" %domain-name))
                            (ssl-certificate
                             (format #f "~a/fullchain.pem" certs-path))
                            (ssl-certificate-key
                             (format #f "~a/privkey.pem" certs-path)))

                          (nginx-server-configuration
                            (listen '("443 ssl"))
                            (server-name
                             (list (format #f "*.pub.~a" %domain-name)))
                            (locations
                             (list (nginx-location-configuration
                                     (uri "/")
                                     (body
                                      (list (format #f "proxy_pass http://[~a]/;"
                                                    %ipv6-wireguard-host)
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
