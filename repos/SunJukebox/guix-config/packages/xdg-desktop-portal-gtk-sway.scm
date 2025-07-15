(define-module (anon packages xdg-desktop-portal-gtk-sway)
   #:use-module (gnu)
   #:use-module (guix)
   #:use-module (guix packages)

   #:use-module (gnu packages freedesktop))  ;; contains calcurse
 
(define-public xdg-desktop-portal-gtk-sway
  (package
    (inherit xdg-desktop-portal-gtk)
    (name "xdg-desktop-portal-gtk-sway")
    (version "1.14.1")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/flatpak/xdg-desktop-portal-gtk/releases/download/"
                    version "/xdg-desktop-portal-gtk-" version ".tar.xz"))
              (sha256
                (base32
                  "002p19j1q3fc8x338ndzxnicwframpgafw31lwvv5avy329akqiy"))
              (patches (list (local-file "xdg-desktop-portal-gtk-sway.patch")))))))
