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
             (guix gexp)
             (guix packages)
             (guix git-download)
             (guix build-system guile)
             (gnu packages guile)
             (gnu packages emacs)
             (gnu packages bash)
             (gnu packages guile-xyz)
             (gnu packages texinfo)
             (gnu packages rust-apps)
             (gnu packages build-tools)
             ((guix licenses)
              #:prefix license:))

(define-public guile-veritas
  (package
    (name "guile-veritas")
    (version "0.1.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/jjba23/veritas.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0yg9qqwlln6y9ay1yljxq4x35il5bz7fl7j9nz5dygvdfffqs1v0"))))
    (build-system guile-build-system)
    (arguments
     (list
      #:source-directory "src"))
    (native-inputs (list guile-3.0))
    (propagated-inputs (list guile-fibers guile-json-4))
    (home-page "https://codeberg.org/jjba23/veritas")
    (synopsis "Testing framework for Guile")
    (description
     "Veritas is a testing framework for Guile with an @acronym{EDSL,
embedded domain specific language} to define test suites.  Emphasis is placed
on legibility and maintainability of tests.  Veritas shuffles tests and
runs them concurrently by default to ensure robust testing practices.")
    (license license:lgpl3+)))

(define-public maak
  (package
    (name "maak")
    (version "0.2.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/jjba23/maak.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "12vvbvkfqdrsqyxplgg5skdi1akr3h6pvv67iln8zk1rnqkyhqx6"))))
    (arguments
     (list
      #:source-directory "src"
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'install-program-files
            (lambda _
              (let ((bin (string-append #$output "/bin"))
                    (share (string-append #$output "/share")))
                (install-file "resources/help.txt"
                              (string-append share "/resources"))
                (install-file "scripts/maak" bin)
                (install-file "scripts/log.bash"
                              (string-append share "/scripts/"))
                (install-file "scripts/maak-completion.bash"
                              (string-append share "/scripts/"))
                (chmod (string-append bin "/maak") #o755)))))))
    (build-system guile-build-system)
    (native-inputs (list guile-3.0))
    (inputs (list guile-3.0 bash-minimal))
    (synopsis "Command runner à la Make using Guile Scheme")
    (description
     "Maak is a command runner and control plane for your
projects.  It allows you to use the power of Lisp (Guile Scheme) to define
your tasks, build steps, repetitive tasks or other automation.

With Maak you can easily call external shell commands and integrate with
your existing scripts and tools.")
    (home-page "https://codeberg.org/jjba23/maak")
    (license license:gpl3+)))

(packages->manifest (list guile-next
                          guile-ares-rs
                          emacs
                          guile-veritas
                          (specification->package "gettext")
                          maak
                          coreutils
                          guile-documenta
                          watchexec
                          texinfo))
