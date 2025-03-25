(define-module (yggdrasil modules transmission)
  #:use-module (gnu home services)
  #:use-module ((rde home services bittorrent)
                #:select (home-transmission-service-type
                          home-transmission-configuration)))


(define (home-services)
  (list
   (service
    home-transmission-service-type
    (home-transmission-configuration
     (auto-start? #t)
     (download-dir "dls/torrents")))))
