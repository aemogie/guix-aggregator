(define-module (home services texlive)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu packages)
  #:use-module (gnu services)

  #:export (home-texlive-service-type))

(use-package-modules tex)

(define (home-texlive-profile-service config)
  (list texlive-scheme-basic 
        texlive-collection-latexrecommended
        texlive-collection-fontsrecommended 

        texlive-cancel
        texlive-emptypage
        texlive-enumitem
        texlive-environ
        texlive-ifmtarg
        texlive-import
        texlive-latexindent
        texlive-latexmk
        texlive-mdframed
        texlive-needspace
        texlive-pdfcol
        texlive-siunitx
        texlive-stmaryrd
        texlive-systeme
        texlive-tcolorbox
        texlive-todonotes
        texlive-transparent
        texlive-xifthen
        texlive-xstring
        texlive-zref))

(define home-texlive-service-type
  (service-type (name 'home-texlive)
                (description "My TeX Live environment service.")
                (extensions (list (service-extension
                                   home-profile-service-type
                                   home-texlive-profile-service)))
                (default-value #f)))
