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

(define-module (sss-packages maak)
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
  #:export (maak))

(define maak
  (package
    (name "maak")
    (version "0.1.14")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://codeberg.org/jjba23/maak.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0c3h8xqlwb0xj84ikjngnccmlv1iyh1zg3xnmzd7fwj7ljvcxvfb"))))
    (build-system guile-build-system)
    (arguments
     (list
      #:source-directory "src"
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'install-program-files
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((bin (string-append (assoc-ref outputs "out") "/bin"))
                    (share (string-append (assoc-ref outputs "out") "/share")))
                (install-file "resources/help.txt"
                              (string-append share "/resources"))
                (install-file "scripts/maak" bin)
                (install-file "scripts/log.bash"
                              (string-append share "/scripts/"))
                (chmod (string-append bin "/maak") #o755)))))))
    (native-inputs (list guile-3.0))
    (inputs (list guile-3.0 bash-minimal))
    (home-page "https://codeberg.org/jjba23/maak")
    (synopsis "Command runner à la Make using Guile Scheme")
    (description
     "Maak is a command runner and control plane for your
projects.  It allows you to use the power of Lisp (Guile Scheme) to define
your tasks, build steps, repetitive tasks or other automation.

With Maak you can easily call external shell commands and integrate with
your existing scripts and tools.  It is inspired by the GNU Make utility
but it does away with a lot of the complexity that comes with its history.")
    (license license:gpl3+)))

