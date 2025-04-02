(define-module (mrh-guix system vps)
  #:use-module (gnu)
  #:use-module (gnu services certbot)
  #:use-module (gnu packages rsync)
  #:use-module (beaver system)
  #:use-module (beaver functional-services)
  #:use-module (mrh-guix personal))

(->
 (minimal-ovh %ssh-key)
 (add-service certbot
              (email "mrh57@posteo.net")
              (certificates
               (list (certificate-configuration
                      (domains '("wumpus.pizza"))))))
 (httpx-static-content #:from-host "wumpus.pizza"
                       #:fullchain-path "/etc/certs/wumpus.pizza/fullchain.pem"
                       #:privkey-path "/etc/certs/wumpus.pizza/privkey.pem")
 (packages rsync))
