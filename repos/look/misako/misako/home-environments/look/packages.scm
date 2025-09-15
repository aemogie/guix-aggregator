(define-module (misako home-environments look packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix transformations)
  #:use-module (guix utils)
  #:use-module (saayix packages terminals)
  #:export (ghostty-tip))

(define ghostty-tip
  ((options->transformation
     '((with-commit . "ghostty=9d9d781a0b7142ddc176167ef5e889618d295ef5")))
   ghostty))

ghostty-tip
