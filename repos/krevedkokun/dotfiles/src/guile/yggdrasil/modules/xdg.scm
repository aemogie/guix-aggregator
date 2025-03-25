(define-module (yggdrasil modules xdg)
  #:use-module (gnu home services)
  #:use-module ((gnu home services xdg)
                #:select (home-xdg-user-directories-service-type
                          home-xdg-user-directories-configuration))
  #:use-module ((gnu packages freedesktop) #:select (xdg-utils))
  #:use-module (gnu services))

(define (home-services)
  (list
   (service
    home-xdg-user-directories-service-type
    (home-xdg-user-directories-configuration
     (download "$HOME/dls")
     (videos "$HOME/video")
     (music "$HOME/music")
     (pictures "$HOME/img")
     (documents "$HOME/docs")
     (publicshare "$HOME")
     (templates "$HOME")
     (desktop "$HOME")))

   (simple-service 'xdg-packages
     home-profile-service-type
     (list xdg-utils))))
