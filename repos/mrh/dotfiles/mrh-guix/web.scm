(define-module (mrh-guix web)
  #:use-module (mrh-guix personal)
  #:use-module (gnu services)
  #:use-module (gnu services web)
  #:export (root-server-block
            app-server-block))

(define (root-server-block name ipv6-listen)
  (nginx-server-configuration
    (listen
     (list (format #f "[~a]:80" ipv6-listen)))
    (server-name
     (list (format #f "~a.~a" name %domain-name)))
    (locations
     (list (nginx-location-configuration
             (uri "/")
             (body '("return 405;")))))))

(define* (app-server-block
          name ipv6-listen ipv6-target
          #:key certs-path port (additional-names '()) (extra '()))
  (nginx-server-configuration
    (listen
     (list (format #f (if certs-path
                          "[~a]:443 ssl"
                          "[~a]:80")
                   ipv6-listen)))
    (server-name
     (map (lambda (name)
            (format #f "~a.~a" name %domain-name))
          (cons name additional-names)))
    (locations
     (list (nginx-location-configuration
             (uri "/")
             (body
              (cons (if port
                        (format #f "proxy_pass http://[~a]:~a/;" ipv6-target port)
                        (format #f "proxy_pass http://[~a]/;" ipv6-target))
                    extra)))))
    (ssl-certificate (if certs-path
                         (format #f "~a/fullchain.pem" certs-path)
                         #f))
    (ssl-certificate-key (if certs-path
                             (format #f "~a/privkey.pem" certs-path)
                             #f))))
