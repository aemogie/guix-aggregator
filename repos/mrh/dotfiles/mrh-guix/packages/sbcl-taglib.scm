(define-module (mrh-guix packages sbcl-taglib)
  #:use-module (gnu packages lisp-xyz)
  #:use-module (guix build-system asdf)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:))

(define-public sbcl-taglib
  (package
    (name "sbcl-taglib")
    (version "0.0.0")
    (home-page "https://github.com/mv2devnul/taglib")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mv2devnul/taglib")
             (commit "8611ef260c67fa09df721f2614158dde35f6f2bf")))
       (sha256 (base32 "1jhi38g2ngmbsv71chxyavgf4fzb64nr7z648ia01qxii0435csb"))))
    (propagated-inputs (list cl-bordeaux-threads cl-optima cl-flexi-streams cl-ppcre))
    (build-system asdf-build-system/sbcl)
    (synopsis "A pure Lisp implementation for reading audio tags and information.")
    (description "A pure Lisp implementation for reading audio tags and audio information.")
    (license license:unlicense)))

;; (use-modules (gnu packages lisp)
;;              (guix profiles))
;; (packages->manifest (list sbcl sbcl-taglib))

