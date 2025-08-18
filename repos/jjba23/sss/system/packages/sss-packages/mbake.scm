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

(define-module (sss-packages mbake)
  #:declarative? #t
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system python)
  #:use-module (guix build-system pyproject)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python)
  #:export (mbake))

(define mbake
  (package
    (name "mbake")
    (version "1.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "mbake" version))
       (sha256
        (base32 "1badaaw5cxbca7fqahjm6j5yk6mmcakc4772q9gdrr84jx9wjd67"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-rich python-tomli python-typer))
    (native-inputs (list python-black
                         python-hatchling
                         python-mypy
                         python-pytest
                         python-pytest-cov
                         ;; TODO enable when Ruff is upstreamed
                         ;; python-ruff
                         python-tomli))
    (home-page "https://github.com/EbodShojaei/bake")
    (synopsis "A Python-based Makefile formatter and linter")
    (description
     "This package provides a Python-based Makefile formatter and linter.")
    (license license:expat)))

