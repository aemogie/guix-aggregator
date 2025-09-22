(define-module (mrh-guix system om web)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (mrh-guix system om networking)
  #:use-module (gnu services)
  #:use-module (gnu services web))

(define* (make-server-config ipv6 name port #:key (extra '()))
  (nginx-server-configuration
    (listen (list (format #f "[~a]:443 ssl" ipv6)))
    (server-name (list (format #f "~a.~a" name %domain-name)))
    (locations
     (list (nginx-location-configuration
             (uri "/")
             (body (cons (format #f "proxy_pass http://[::1]:~a/;" port)
                         extra)))))
    (ssl-certificate (string-append %domain-certs-dir "/fullchain.pem"))
    (ssl-certificate-key (string-append %domain-certs-dir "/privkey.pem"))))

(define (root-server-config ipv6 name)
  (nginx-server-configuration
    (listen (list (format #f "[~a]:443 ssl" ipv6)))
    (server-name (list (format #f "~a.~a" name %domain-name)))
    (locations
     (list (nginx-location-configuration
             (uri "/")
             (body '("return 405;")))))
    (ssl-certificate (string-append %domain-certs-dir "/fullchain.pem"))
    (ssl-certificate-key (string-append %domain-certs-dir "/privkey.pem"))))

(define-public %nginx-service
  (service
   nginx-service-type
   (nginx-configuration
     (server-blocks
      (list
       (root-server-config %lan-ipv6 "pub")
       (root-server-config %wireguard-ipv6-host "home")
       (make-server-config %wireguard-ipv6-host "syncthing.home" 8384)
       (make-server-config %wireguard-ipv6-host "sab.home" 8081)
       (make-server-config %wireguard-ipv6-host "i2p.home" 7070)
       (make-server-config
        %wireguard-ipv6-host "jelly.home" 8096
        #:extra '("proxy_set_header Host $host;"
                  "proxy_set_header X-Real-IP $remote_addr;"
                  "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                  "proxy_set_header X-Forwarded-Proto $scheme;"
                  "proxy_set_header X-Forwarded-Protocol $scheme;"
                  "proxy_set_header X-Forwarded-Host $http_host;"
                  "proxy_buffering off;"))
       (make-server-config
        %lan-ipv6 "jelly.pub" 8096
        #:extra '("proxy_set_header Host $host;"
                  "proxy_set_header X-Real-IP $remote_addr;"
                  "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                  "proxy_set_header X-Forwarded-Proto $scheme;"
                  "proxy_set_header X-Forwarded-Protocol $scheme;"
                  "proxy_set_header X-Forwarded-Host $http_host;"
                  "proxy_buffering off;")))))))
