(define-module (mrh-guix system vps config)
  #:use-module (mrh-guix personal)
  #:use-module (beaver system)
  #:use-module (beaver functional-services)
  #:use-module (gnu)
  #:use-module (gnu services certbot)
  #:use-module (gnu services networking))

(use-package-modules admin rsync)

(let ((certs-path "/etc/certs/wumpus.pizza"))
  (-> (minimal-ovh %ssh-pub)

      (add-service
       nftables
       (ruleset
        (plain-file "nftables.conf"
                    (local-file "nftables.conf"))))

      (add-service
       certbot
       (email "mrh57@posteo.net")
       (certificates
        (list (certificate-configuration
               (domains '("wumpus.pizza"
                          "www.wumpus.pizza"
                          "home.wumpus.pizza"
                          "*.home.wumpus.pizza"
                          "pub.wumpus.pizza"
                          "*.pub.wumpus.pizza"))))))

      (httpx-reverse-proxy
       #:from-host "www.wumpus.pizza"
       #:to-port 8080
       #:fullchain-path (format #f "~a/fullchain.pem" certs-path)
       #:privkey-path (format #f "~a/privkey.pem" certs-path))

      (httpx-reverse-proxy
       #:from-host "wumpus.pizza"
       #:to-port 8081
       #:fullchain-path (format #f "~a/fullchain.pem" certs-path)
       #:privkey-path (format #f "~a/privkey.pem" certs-path))

      (http-static-content
       #:from-host "localhost"
       #:from-port 8081
       #:to-dir "/var/www/wumpus.pizza")

      (packages btop rsync)))
