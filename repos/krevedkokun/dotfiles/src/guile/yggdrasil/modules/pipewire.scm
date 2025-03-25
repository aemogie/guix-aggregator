(define-module (yggdrasil modules pipewire)
  #:use-module (gnu home services)
  #:use-module ((gnu packages audio) #:select (easyeffects))
  #:use-module ((gnu packages freedesktop)
                #:select (xdg-desktop-portal
                          xdg-desktop-portal-gtk
                          xdg-desktop-portal-wlr))
  #:use-module ((gnu packages linux) #:select (pipewire))
  #:use-module ((gnu packages pulseaudio) #:select (pavucontrol))
  #:use-module (gnu services)
  #:use-module ((gnu services base) #:select (udev-rules-service))
  #:use-module (guix gexp)
  #:use-module ((yggdrasil home services pipewire)
                #:select (home-pipewire-service-type))
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(use-modules ((gnu packages image) #:select (slurp)))

(define (home-services)
  (list
   (service home-pipewire-service-type)
   (simple-service 'sway-pavucontrol-config
     home-sway-service-type
     `((assign "[app_id=\"pavucontrol\"]" MISC)))
   (simple-service 'pipewire-packages
     home-profile-service-type
     (list pavucontrol
           easyeffects
           #;xdg-desktop-portal-gtk
           xdg-desktop-portal
           xdg-desktop-portal-wlr))
   (simple-service 'xdg-desktop-portal-configs
     home-xdg-configuration-files-service-type
     `(("xdg-desktop-portal-wlr/config"
        ,(mixed-text-file
          "config"
          "[screencast]\n"
          "max_fps=30\n"
          #~(string-append "chooser_cmd=" #$slurp "/bin/slurp -f %o -or -c '#ff0000ff' -w 5\n")
          "chooser_type=simple\n"))
       #;("xdg-desktop-portal/portals.conf"
        ,(plain-file
          "portals.conf"
          "[preferred]
default=gtk
org.freedesktop.impl.portal.Screencast=wlr
org.freedesktop.impl.portal.Screenshot=wlr"))))))

(define (system-services)
  (list
   (udev-rules-service 'pipewire-udev pipewire)))
