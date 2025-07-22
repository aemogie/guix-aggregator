;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

(use-modules (guix)
             (guix packages)
             (guix git-download)
             (guix build-system guile)
             (gnu packages guile)
             (gnu packages emacs)
             (gnu packages guile-xyz)
             ((guix licenses)
              #:prefix license:))

(define-public guile-veritas
  (package
    (name "guile-veritas")
    (version "0.0.18")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/jjba23/veritas.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0f8maqgg1fahw9cfcvcrlff3hv9bw9d8z769va3az0bd7rkx14hb"))))
    (build-system guile-build-system)
    (native-inputs (list guile-3.0 guile-fibers))
    (arguments
     (list
      #:source-directory "src"))
    (home-page "https://codeberg.org/jjba23/veritas")
    (synopsis
     "Unit, Integration and Black Box testing framework powered by Lisp (Guile Scheme)")
    (description
     "veritas aims to be a simple and lightweight testing framework written in Scheme. Its main purpose is to help developers verify that their code behaves as expected. It achieves this by providing a clear structure for writing tests and producing easy-to-read feedback in various formats.

The framework is built around the concepts of \"suites\" which group related \"tests\" and \"assertions\" which perform the actual checks. I'd encourage you to peruse the ~test/~ folder of this project to see real examples of how to use veritas.

The power of ~veritas~ lies in its simplicity, expressive embedded domain-specific language (EDSL), and some clever features that promote robust testing practices and correctness, like order randomization and concurrent testing.")
    (license license:lgpl3+)))

(packages->manifest (list guile-next
                          guile-ares-rs
                          emacs
                          guile-veritas
                          (specification->package "gettext")
                          (specification->package "make")
                          coreutils))
