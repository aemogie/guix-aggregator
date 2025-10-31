(define-module (mrh-guix web)
  #:use-module (mrh-guix personal)
  #:use-module (gnu services)
  #:use-module (gnu services web))

(define-public (root-server-block name ipv6-listen)
  (nginx-server-configuration
    (listen
     (list (format #f "[~a]:80" ipv6-listen)))
    (server-name
     (list (format #f "~a.~a" name %domain-name)))
    (locations
     (list (nginx-location-configuration
             (uri "/")
             (body '("return 405;")))))))

(define-public (app-server-block name ipv6-listen port . extra)
  (nginx-server-configuration
    (listen
     (list (format #f "[~a]:80" ipv6-listen)))
    (server-name
     (list (format #f "~a.~a" name %domain-name)))
    (locations
     (list (nginx-location-configuration
             (uri "/")
             (body (cons (format #f "proxy_pass http://[::1]:~a/;" port)
                         extra)))))))
