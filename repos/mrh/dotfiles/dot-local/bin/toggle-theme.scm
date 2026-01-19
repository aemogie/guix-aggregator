#!/usr/bin/env guile
!#

(use-modules (ice-9 popen)
             (ice-9 textual-ports))

(define (switch-theme theme dark)
  (system
   (format #f "gsettings set org.gnome.desktop.interface gtk-theme ~a" theme))
  (if dark
      (begin
        (system
         "gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
        (system
         "emacsclient -e \"(modus-themes-load-theme 'ef-melissa-dark)\""))
      (begin
        (system
         "gsettings set org.gnome.desktop.interface color-scheme prefer-light")
        (system
         "emacsclient -e \"(modus-themes-load-theme 'ef-melissa-light)\""))))

(define current-theme
  (string-trim-both
   (get-line (open-input-pipe
              "gsettings get org.gnome.desktop.interface gtk-theme"))
   #\'))

(if (string=? current-theme "Adwaita")
    (switch-theme "Adwaita-dark" #t)
    (switch-theme "Adwaita" #f))
