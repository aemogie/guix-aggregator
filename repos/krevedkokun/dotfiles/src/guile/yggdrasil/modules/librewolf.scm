(define-module (yggdrasil modules librewolf)
  #:use-module (gnu home services)
  #:use-module ((gnu home services xdg)
                #:select (home-xdg-mime-applications-service-type
                          home-xdg-mime-applications-configuration))
  #:use-module (gnu packages librewolf)
  #:use-module (gnu services)
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(define (home-services)
  (list
   (simple-service 'librewolf-package
     home-profile-service-type
     (list librewolf))
   (simple-service 'librewolf-xdg-mime
     home-xdg-mime-applications-service-type
     (home-xdg-mime-applications-configuration
      (default
        '((x-scheme-handler/http . librewolf.desktop)
          (x-scheme-handler/https . librewolf.desktop)))))
   (simple-service 'sway-librewolf-config
     home-sway-service-type
     `((assign "[app_id=\"librewolf-default\"]" WEB)
       (for_window
        "[app_id=\"librewolf-default\" title=\"LibreWolf — Sharing Indicator\"]"
        kill)))))
