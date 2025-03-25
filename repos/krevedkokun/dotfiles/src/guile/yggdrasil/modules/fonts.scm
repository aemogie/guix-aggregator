(define-module (yggdrasil modules fonts)
  #:use-module (gnu home services)
  #:use-module ((gnu packages fonts)
                #:select (font-iosevka
                          font-iosevka-etoile
                          font-google-noto-emoji
                          font-sarasa-gothic))
  #:use-module (gnu services))

(define (home-services)
  (list
   (simple-service 'font-packages
     home-profile-service-type
     (list font-iosevka
           font-iosevka-etoile
           font-google-noto-emoji
           font-sarasa-gothic))))

'((alias
   (family "sans-serif")
   (prefer
    (family (font-name font-sans))))
  (alias
   (family "serif")
   (prefer
    (family (font-name font-serif))))
  (alias
   (family "monospace")
   (prefer
    (family (font-name font-monospace))))
  (alias
   (family "emoji")
   (prefer
    (family (font-name font-unicode)))))
