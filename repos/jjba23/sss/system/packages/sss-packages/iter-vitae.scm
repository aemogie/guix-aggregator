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

(define-module (sss-packages iter-vitae)
  #:declarative? #t
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system guile)
  #:use-module (gnu packages)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:export (iter-vitae))

(define iter-vitae
  (package
    (name "iter-vitae")
    (version "0.4.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/jjba23/iter-vitae.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02mi1lnpq17whz0lvwd3hd6s72yzrwwr4liw0gnkvj76682i3vvd"))))
    (arguments
     `(#:source-directory "src"
       #:phases (modify-phases %standard-phases
                  (add-before 'build 'install-program-files
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((bin (string-append (assoc-ref outputs "out")
                                                "/bin"))
                            (share (string-append (assoc-ref outputs "out")
                                                  "/share")))
                        (install-file "resources/help.txt"
                                      (string-append share "/resources"))
                        (install-file "resources/css/iter-vitae.olive.min.css"
                         (string-append share "/resources/css"))
                        (install-file "scripts/iter-vitae" bin)
                        (install-file "scripts/log.sh"
                                      (string-append share "/scripts/"))
                        (chmod (string-append bin "/iter-vitae") #o755)))))))
    (build-system guile-build-system)
    (native-inputs (list guile-3.0))
    (inputs (list guile-3.0 bash-minimal))
    (synopsis
     "Resume / @acronym{CV, Curriculum Vitae} generator written in Guile Scheme")
    (description
     "Iter Vitae is a command-line utility that allows you to generate a
Resume / @acronym{CV, Curriculum Vitae}, by reading a S-expression version
of your CV details (in Scheme code).

With a @acronym{MVC, model-view-controller} approach,
it lets you separate the data from the presentation (how the document looks).

This tool creates a web-site version of your CV (using SXML and Olive CSS),
and is designed for long-term use, so you can update and evolve your CV over the years.
The program supports multilingual content and is fully extensible.")
    (home-page "https://codeberg.org/jjba23/iter-vitae")
    (license license:agpl3+)))


