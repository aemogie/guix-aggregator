(define-module (polterguix packages desktop)
  #:use-module (guix)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system trivial)
  #:use-module ((guix licenses) #:prefix license:))

(define-public rofi-extra
  (package
    (name "rofi-extra")
    (version "1.7.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/adi1090x/rofi.git")
             (commit version)))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1k3vr25gr40852mkig4glppv50z4ipa0yrrn60dsy0jy8rpc6kmp"))))
    (build-system trivial-build-system)
    (home-page "https://github.com/adi1090x/rofi")
    (synopsis "A huge collection of Rofi based custom Applets, Launchers & Powermenus.")
    (description
     "A huge collection of Rofi based custom Applets, Launchers & Powermenus.")
    (license license:gpl3+)))
