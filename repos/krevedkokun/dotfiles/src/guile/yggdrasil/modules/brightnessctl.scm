(define-module (yggdrasil modules brightnessctl)
  #:use-module ((gnu packages linux) #:select (brightnessctl))
  #:use-module (gnu services)
  #:use-module ((gnu services base) #:select (udev-rules-service))
  #:use-module (guix gexp)
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(define (home-services)
  (list
   (simple-service 'sway-bindsym-brightnessctl
     home-sway-service-type
     `(( bindsym --locked
         ((XF86MonBrightnessUp exec ,(file-append brightnessctl "/bin/brightnessctl") set #{+10%}#)
          (XF86MonBrightnessDown exec ,(file-append brightnessctl "/bin/brightnessctl") set #{10%-}#)))))))

(define (system-services)
  (list
   (udev-rules-service 'brightnessctl-udev brightnessctl)))
