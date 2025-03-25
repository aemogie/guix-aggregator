(define-module (yggdrasil modules gtk)
  #:use-module (gnu home services)
  #:use-module ((gnu packages glib) #:select (glib))
  #:use-module ((gnu packages gnome)
                #:select (adwaita-icon-theme
                          gnome-themes-extra
                          gsettings-desktop-schemas))
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module ((rde home services wm) #:select (home-sway-service-type)))

(define (home-services)
  (let ((gsettings #~(string-append #$glib:bin "/bin/gsettings"))
        (schema 'org.gnome.desktop.interface))
    (list
     (simple-service 'gtk-settings
       home-profile-service-type
       (list adwaita-icon-theme
             gnome-themes-extra
             gsettings-desktop-schemas))
     (simple-service 'gtk-settings
       home-sway-service-type
       `((seat * xcursor_theme Adwaita 24)
         (exec_always ,gsettings set ,schema cursor-theme Adwaita)
         (exec_always ,gsettings set ,schema cursor-size 24))))))
