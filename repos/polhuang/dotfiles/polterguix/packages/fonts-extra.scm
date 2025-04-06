(define-module (polterguix packages fonts-extra)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system font)
  #:use-module ((guix licenses) #:prefix license:))

(define-public font-jetbrains-mono-nerd
  (package
    (name "font-jetbrains-mono-nerd")
    (version "3.3.0") ; Replace with the latest version
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/ryanoasis/nerd-fonts/releases/download/v" version "/JetBrainsMono.tar.xz"))
              (sha256
               (base32
                "1qcdcrm0mcyfz7v2g74q67q97p5383kax8giig02zqjbi2iiw5vx")))) ; Replace with the correct hash
    (build-system font-build-system)
    (home-page "https://www.nerdfonts.com/font-downloads")
    (synopsis "JetBrainsMono Nerd Font")
    (description "JetBrainsMono font patched with Nerd Font glyphs.")
    (license license:expat)))
