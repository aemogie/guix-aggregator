(define-module (yggdrasil modules multimedia)
  #:use-module (gnu home services)
  #:use-module ((gnu home services xdg)
                #:select (home-xdg-mime-applications-service-type
                          home-xdg-mime-applications-configuration))
  #:use-module ((gnu packages gstreamer)
                #:select (gstreamer
                          gst-libav
                          gst-plugins-base
                          gst-plugins-good
                          gst-plugins-bad
                          gst-plugins-ugly))
  #:use-module ((gnu packages video) #:select (ffmpeg))
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module ((rde home services video)
                #:select (home-mpv-service-type
                          home-mpv-configuration))
  #:use-module ((rde packages video) #:select (mpv-uosc mpv-thumbfast)))

(define (home-services)
  (list
   (simple-service 'multimedia-packages
     home-profile-service-type
     (list ffmpeg
           gstreamer
           gst-libav
           gst-plugins-base
           gst-plugins-good
           gst-plugins-bad
           gst-plugins-ugly))
   (simple-service 'mpv-uosc
     home-xdg-configuration-files-service-type
     `(("mpv/fonts" ,(file-append mpv-uosc "/share/mpv/fonts"))
       ("mpv/scripts/thumbfast.lua"
        ,(file-append mpv-thumbfast "/share/mpv/scripts/thumbfast.lua"))
       ("mpv/script-opts/thumbfast.conf"
        ,(mixed-text-file "thumbfast.conf" "network=yes"))
       ("mpv/scripts/uosc.lua"
        ,(file-append mpv-uosc "/share/mpv/scripts/uosc.lua"))
       ("mpv/scripts/uosc_shared"
        ,(file-append mpv-uosc "/share/mpv/scripts/uosc_shared"))))
   (simple-service 'mpv-xdg-mime
     home-xdg-mime-applications-service-type
     (home-xdg-mime-applications-configuration
      (default
        '((video/mp4 . mpv.desktop)
          (video/mkv . mpv.desktop)
          (video/webm . mpv.desktop)))))
   (service
    home-mpv-service-type
    (home-mpv-configuration
     (mpv-conf
      '((global ((hwdec . auto-safe)
                 (osc . no)
                 (osd-bar . no)
                 (border . no)))))))))
