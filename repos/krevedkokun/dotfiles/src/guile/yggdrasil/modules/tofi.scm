(define-module (yggdrasil modules tofi)
  #:use-module (gnu home services)
  #:use-module ((gnu packages freedesktop) #:select (wtype))
  #:use-module ((gnu packages password-utils) #:select (tessen))
  #:use-module ((gnu packages security-token) #:select (yubikey-oath-dmenu))
  #:use-module ((gnu packages xdisorg) #:select (tofi))
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type)))

(define yubikey-oath-dmenu*
  (package/inherit yubikey-oath-dmenu
    (inputs
     (modify-inputs (package-inputs yubikey-oath-dmenu)
       (prepend wtype)))
    (arguments
     (substitute-keyword-arguments (package-arguments yubikey-oath-dmenu)
       ((#:phases phases)
        #~(modify-phases #$phases
            (replace 'fix-paths
              (lambda* (#:key inputs #:allow-other-keys)
                (substitute* "yubikey-oath-dmenu.py"
                  (("'(dmenu|notify-send|wl-copy|xclip|xdotool|wtype)" _ tool)
                   (string-append
                    "'"
                    (search-input-file inputs (string-append "/bin/" tool)))))))))))))

(define (home-services)
  (list
   (simple-service 'tofi-packages
     home-profile-service-type
     (list tofi))
   (simple-service 'xdg-desktop-portal-configs
     home-xdg-configuration-files-service-type
     `(("tofi/config"
        ,(mixed-text-file
          "config"
          "matching-algorithm=fuzzy\n"
          "font=Iosevka Light\n"
          "font-size=20\n"
          "background-color=#FFFFFF\n"
          "outline-width=0\n"
          "border-width=2\n"
          "border-color=#000000\n"
          "text-color=#000000\n"
          "prompt-color=#721045\n"
          "selection-color=#FFFFFF\n"
          "selection-background=#721045\n"
          "selection-background-padding=4\n"
          "result-spacing=8\n"
          "width=50%\n"
          "height=50%\n"))))
   (simple-service 'sway-bindsym-tofi
     home-sway-service-type
     `(( bindsym
         (($mod+space exec ,(file-append tofi "/bin/tofi-run") "|" xargs swaymsg exec --)
          ($mod+f exec ,(file-append tessen "/bin/tessen") -d tofi -a autotype)
          ($mod+Shift+f exec ,(file-append tessen "/bin/tessen") -d tofi -a copy)
          ($mod+o
           exec
           ,(file-append yubikey-oath-dmenu* "/bin/yubikey-oath-dmenu")
           --type
           --menu-cmd ,(file-append tofi "/bin/tofi"))
          ($mod+Shift+o
           exec
           ,(file-append yubikey-oath-dmenu* "/bin/yubikey-oath-dmenu")
           --clipboard
           --notify
           --menu-cmd ,(file-append tofi "/bin/tofi"))))))))
