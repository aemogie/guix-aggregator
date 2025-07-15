(define-module (anon packages python-pdf)
  #:use-module (gnu)
  #:use-module (guix)

  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages ocr)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages web)

  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module ((guix licenses) #:select (agpl3+)))
  ;; #:use-module ((guix licenses) #:prefix license:))

;; (define-public python-pymupdf
;;   (package
;;     (name "python-pymupdf")
;;     (version "1.26.3")
;;     (source
;;      (origin
;;        (method url-fetch)
;;        (uri (pypi-uri "pymupdf" version))
;;        (sha256
;;         (base32 "1rdpfg5f5g5vjc853d1pwdgsymnkrksn526i2r21w3l7m7zw7lmp"))))
;;     (build-system pyproject-build-system)
;;     (home-page #f)
;;     (synopsis
;;      "A high performance Python library for data extraction, analysis, conversion & manipulation of PDF (and other) documents.")
;;     (description
;;      "This package provides a high performance Python library for data extraction,
;; analysis, conversion & manipulation of PDF (and other) documents.")
;;     (license #f)))

(define-public python-pymupdf
  (package
   (name "python-pymupdf")
    (version "1.26.3")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pymupdf" version))
       (sha256
        (base32 "1rdpfg5f5g5vjc853d1pwdgsymnkrksn526i2r21w3l7m7zw7lmp"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:test-flags #~(list "-k" "not test_color_count")
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'set-build-env
            (lambda _
              (let ((include-mupdf
                     #$(file-append (this-package-input "mupdf") "/include")))
                (substitute* "setup.py"
                  (("^include_dirs = .*$")
                   (string-append
                    "include_dirs = [ \"" include-mupdf "/mupdf\", \""
                    #$(file-append
                       (this-package-input "freetype") "/include/freetype2")
                    "\"]\n"))
                  (("^extra_swig_args = .*$")
                   (string-append
                    "extra_swig_args = [ \"-I" include-mupdf "\" ]\n"))))
              (setenv "CC" "gcc")
              (setenv "USE_SYSTEM_LIBS" "yes")
              (setenv "PYMUPDF_SETUP_MUPDF_BUILD" "")
              (setenv "PYMUPDF_SETUP_MUPDF_THIRD" "0"))))))
    (inputs (list mupdf
                  freetype
                  gumbo-parser
                  harfbuzz
                  jbig2dec
                  libjpeg-turbo
                  openjpeg
                  tesseract-ocr))
    (native-inputs (list gcc
                         pkg-config
                         swig
                         python-pytest
                         python-fonttools))
    (home-page "https://github.com/pymupdf/PyMuPDF")
    (synopsis "Python bindings for the PDF toolkit and renderer MuPDF")
    (description "This package provides a Python library for data extraction,
analysis, conversion & manipulation of PDF (and other) documents.")
    (license agpl3+)))

(define-public python-pdf-tocgen
  (package
    (name "python-pdf-tocgen")
    (version "1.3.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pdf_tocgen" version))
       (sha256
        (base32 "17n7i851fcbippx39mfid3rbh3m1smsh1fnh3yppwwhl4s1mh1q9"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-chardet python-pymupdf python-toml))
    (native-inputs (list python-poetry-core))
    (home-page "https://krasjet.com/voice/pdf.tocgen/")
    (synopsis "Automatically generate table of contents for pdf files.")
    (description "Automatically generate table of contents for pdf files.")
    (license #f)))
