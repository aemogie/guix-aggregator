(define-module (packages fonts)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system font)
  #:use-module ((guix licenses) #:prefix license:))

(define-public font-jetbrains-mono-nf
  (package
   (name "font-jetbrains-mono-nf")
   (version "3.2.1")
   (source
    (origin
     (method url-fetch)
     (uri
      (string-append
       "https://github.com/ryanoasis/nerd-fonts/releases/download/v"
       version
       "/JetBrainsMono.zip"))
     (sha256
      (base32
       "1pksy313c9awq155vd1dcs4c6s5c15qa8dkwcnxpd25gmcm955k5"))))
   (build-system font-build-system)
   ;; (arguments
   ;;  `(#:phases
   ;;    (modify-phases %standard-phases
   ;;      (add-before 'install 'make-files-writable
   ;;        (lambda _
   ;;          (for-each
   ;;           make-file-writable
   ;;           (find-files "." ".*\\.(otf|otc|ttf|ttc)$"))
   ;;          #t)))))
   (home-page "https://www.nerdfonts.com/")
   (synopsis "Nerd fonts variant of JetBrainsMono font")
   (description
    "Nerd fonts variant of JetBrainsMono font.  Nerd Fonts is a project that patches
    developer targeted fonts with a high number of glyphs (icons).  Specifically to
    add a high number of extra glyphs from popular 'iconic fonts' such as Font Awesome,
    Devicons, Octicons, and others.")
   (license license:expat)))
