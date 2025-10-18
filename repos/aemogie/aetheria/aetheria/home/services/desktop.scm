(define-module (aetheria home services desktop)
  #:use-module ((gnu services) #:select (service
                                         service-type
                                         service-extension))
  #:use-module ((gnu home services) #:select (home-profile-service-type))
  #:use-module ((gnu home services desktop) #:select (home-dbus-service-type))
  #:use-module ((gnu home services sound) #:select (home-pipewire-service-type))
  #:use-module ((gnu home services shepherd) #:select (home-shepherd-service-type
                                                       home-shepherd-configuration))
  #:use-module ((gnu packages fonts) #:select (font-iosevka
                                               font-iosevka-aile
                                               font-iosevka-etoile
                                               font-iosevka-comfy
                                               font-sarasa-gothic
                                               font-google-noto
                                               font-google-noto-emoji
                                               font-google-noto-sans-cjk
                                               font-google-noto-serif-cjk))
  #:use-module ((gnu packages wm) #:select (hyprland
                                            waybar
                                            cage))
  #:use-module ((gnu packages xdisorg) #:select (wl-clipboard))
  #:use-module ((gnu packages linux) #:select (bluez))
  #:use-module ((gnu packages librewolf) #:select (librewolf))
  #:use-module ((gnu packages terminals) #:select (foot))
  #:use-module ((gnu packages emacs) #:select (emacs-pgtk-xwidgets))
  #:use-module ((gnu packages aspell) #:select (aspell aspell-dict-en))
  #:use-module ((aetheria home services base) #:select (home-base-service-type))
  #:export (home-desktop-service-type
            %aetheria-desktop-home-services))

(define %default-font-packages
  (list font-iosevka
        font-iosevka-aile
        font-iosevka-etoile
        font-iosevka-comfy
        font-sarasa-gothic
        ;; no tofu or something, i dont really know
        font-google-noto
        font-google-noto-emoji
        font-google-noto-sans-cjk
        font-google-noto-serif-cjk))

(define home-font-service-type
  (service-type
   (name 'home-font)
   (description "fonts and stuff")
   (default-value %default-font-packages)
   ;; most applications that use fonts should be using the search path anyway
   (extensions (list (service-extension home-profile-service-type identity)))))

(define %desktop-home-packages
  (list hyprland waybar wl-clipboard cage bluez
        librewolf foot emacs-pgtk-xwidgets aspell aspell-dict-en))

(define home-desktop-service-type
  (service-type
   (name 'home-desktop)
   (description "aetheria setup and configure desktop utlities")
   (default-value #f)
   (extensions (list (service-extension home-base-service-type (const #f))
                     (service-extension home-profile-service-type
                                        (const %desktop-home-packages))
                     (service-extension home-font-service-type (const #f))
                     (service-extension home-dbus-service-type (const #f))
                     (service-extension home-pipewire-service-type (const #f))))))

(define %aetheria-desktop-home-services
  (list
   ;; started from wayland session. dont know how to move this to a service
   (service home-shepherd-service-type
            (home-shepherd-configuration
             (auto-start? #f)
             (daemonize? #f)))
   (service home-desktop-service-type)))
