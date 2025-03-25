(define-module (yggdrasil modules mako)
  #:use-module (gnu home services)
  #:use-module ((gnu packages wm) #:select (mako))
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module ((yggdrasil home services mako)
                #:select (home-mako-service-type
                          home-mako-configuration))
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(define (home-services)
  (list
   (simple-service 'sway-bindsym-mako
     home-sway-service-type
     `(( bindsym
         (($mod+g exec ,(file-append mako "/bin/makoctl") dismiss --all)
          ($mod+m exec ,(file-append mako "/bin/makoctl") set-mode dnd)
          ($mod+Shift+m exec ,(file-append mako "/bin/makoctl") set-mode default)))))
   (service
    home-mako-service-type
    (home-mako-configuration
     (config
      `((sort             . -time)
        (actions          . 0)
        (icons            . 0)
        (font             . "Iosevka Light 14")
        (text-color       . "#000000")
        (background-color . "#FFFFFF")
        (border-color     . "#721045")
        (layer            . overlay)
        (border-size      . 2)
        (padding          . 10)
        (width            . 400)
        (group-by         . app-name)
        (ignore-timeout   . 1)
        (default-timeout  . 3500)
        ((mode dnd)
         (invisible       . 1))))))))
