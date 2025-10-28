(define-module (mrh-guix system om web)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix vpn)
  #:use-module (gnu services)
  #:use-module (gnu services web))

(define (root-server-config name)
  (nginx-server-configuration
    (listen '("[::]:80"))
    (server-name (list (format #f "~a.~a" name %domain-name)))
    (locations
     (list (nginx-location-configuration
             (uri "/")
             (body '("return 405;")))))))

(define (app-server-config name port . extra)
  (nginx-server-configuration
    (listen '("[::]:80"))
    (server-name
     (list (format #f "~a.~a" name %domain-name)))
    (locations
     (list (nginx-location-configuration
             (uri "/")
             (body (cons (format #f "proxy_pass http://[::1]:~a/;" port)
                         extra)))))))

(define-public %nginx-service
  (service
   nginx-service-type
   (nginx-configuration
     (server-blocks
      (list (root-server-config "home")
            (root-server-config "pub")
            (app-server-config "syncthing.home" 8384)
            (app-server-config "sab.home" 8081)
            (app-server-config "i2p.home" 7070)
            (app-server-config "jelly.home" 8096
                               "proxy_set_header Host $host;"
                               "proxy_set_header X-Real-IP $remote_addr;"
                               "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
                               "proxy_set_header X-Forwarded-Proto $scheme;"
                               "proxy_set_header X-Forwarded-Protocol $scheme;"
                               "proxy_set_header X-Forwarded-Host $http_host;"
                               "proxy_buffering off;"))))))
