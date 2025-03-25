(define-module (mrh-guix packages river)
  #:use-module (guix inferior)
  #:use-module (guix channels)
  #:use-module (srfi srfi-1))

(define channels
  (list (channel
         (name 'guix)
         (url "https://git.savannah.gnu.org/git/guix.git")
         (commit "b71c7c472a0a56c6935b4fa2a2e9c78d8ac8ea27")))) ;; c. Oct 2023

(define-public river
  (first (lookup-inferior-packages (inferior-for-channels channels) "river")))
