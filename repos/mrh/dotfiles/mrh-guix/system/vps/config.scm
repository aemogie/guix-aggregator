(define-module (mrh-guix system vps config)
  #:use-module (gnu)
  #:use-module (gnu services certbot)
  #:use-module (beaver system)
  #:use-module (beaver functional-services)
  #:use-module (mrh-guix personal))

(use-package-modules admin
                     lisp
                     lisp-xyz
                     rsync)

(let ((certs-path "/etc/certs/wumpus.pizza"))
  (-> (minimal-ovh %ssh-key)

      (add-service nftables
                   (ruleset (local-file "nftables.conf")))

      (add-service certbot
                   (email "mrh57@posteo.net")
                   (certificates
                    (list (certificate-configuration
                           (domains '("wumpus.pizza" "www.wumpus.pizza"))))))

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
       #:to-dir "/var/www/main")

      (packages btop cl-clog sbcl rsync)))
