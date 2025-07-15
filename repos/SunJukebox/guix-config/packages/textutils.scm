(define-module (anon packages textutils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system ant)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (guix build-system perl)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-compression)
  #:use-module (gnu packages golang-crypto)
  #:use-module (gnu packages golang-xyz)
  #:use-module (gnu packages java)
  #:use-module (gnu packages julia)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages readline)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages slang)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xorg)
  #:use-module (srfi srfi-1))


;; Newer utf8proc depends on julia for tests.  Since julia also depends on
;; utf8proc, a dependency cycle is created.  This bootstrap variant of utf8proc
;; disables tests.
(define-public utf8proc-bootstrap
  (hidden-package
   (package
     (name "utf8proc-bootstrap")
     (version "2.10.0")
     (source
      (origin
        (method git-fetch)
        (uri (git-reference
              (url "https://github.com/JuliaStrings/utf8proc")
              (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32 "1n1k67x39sk8xnza4w1xkbgbvgb1g7w2a7j2qrqzqaw1lyilqsy2"))))
     (build-system gnu-build-system)
     (arguments
      (list #:tests? #f                 ;To break dependency cycle.
            #:make-flags
            #~(list (string-append "CC=" #$(cc-for-target))
                    (string-append "prefix=" #$output))
            #:phases
            #~(modify-phases %standard-phases
                ;; No configure script.
                (delete 'configure))))
     (home-page "https://juliastrings.github.io/utf8proc/")
     (synopsis "C library for processing UTF-8 Unicode data")
     (description
      "@code{utf8proc} is a small C library that provides Unicode normalization,
case-folding, and other operations for data in the UTF-8 encoding.")
     (license license:expat))))

(define-public utf8proc-2.10.0
  (package
    (inherit utf8proc-bootstrap)
    (name "utf8proc")
    (native-inputs
     (let ((UNICODE_VERSION "16.0.0"))  ; defined in data/Makefile
       ;; Test data that is otherwise downloaded with curl.
       (list (origin
               (method url-fetch)
               (uri (string-append
                     "https://www.unicode.org/Public/"
                     UNICODE_VERSION "/ucd/NormalizationTest.txt"))
               (sha256
                (base32
                 "1cffwlxgn6sawxb627xqaw3shnnfxq0v7cbgsld5w1z7aca9f4fq")))
             (origin
               (method url-fetch)
               (uri (string-append
                     "https://www.unicode.org/Public/"
                     UNICODE_VERSION "/ucd/auxiliary/GraphemeBreakTest.txt"))
               (sha256
                (base32
                 "1d9w6vdfxakjpp38qjvhgvbl2qx0zv5655ph54dhdb3hs9a96azf")))
             (origin
               (method url-fetch)
               (uri (string-append
                     "https://www.unicode.org/Public/"
                     UNICODE_VERSION "/ucd/DerivedCoreProperties.txt"))
               (sha256
                (base32
                 "1gfsq4vdmzi803i2s8ih7mm4fgs907kvkg88kvv9fi4my9hm3lrr")))
             ;; For tests.
             julia
             perl
             ;; TODO Move to ruby@3 on the next rebuild cycle.
             ruby-2.7)))
    (arguments
     (strip-keyword-arguments
      '(#:tests?)
      (substitute-keyword-arguments (package-arguments utf8proc-bootstrap)
        ((#:phases phases '%standard-phases)
         #~(modify-phases #$phases
             (add-before 'check 'check-data
               (lambda* (#:key inputs native-inputs #:allow-other-keys)
                 (for-each (lambda (i)
                             (copy-file (assoc-ref (or native-inputs inputs) i)
                                        (string-append "data/" i)))
                           '("NormalizationTest.txt" "GraphemeBreakTest.txt"
                             "DerivedCoreProperties.txt")))))))))
    (properties
     (alist-delete 'hidden? (package-properties utf8proc-bootstrap)))))
