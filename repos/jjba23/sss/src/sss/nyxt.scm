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

(define-module (sss nyxt)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (ice-9 string-fun)
  #:use-module (sss palette)
  #:export (nyxt-capability))

(define* (nyxt-capability)
  `((".config/nyxt/config.lisp" ,(local-file "./nyxt/config.lisp"))
    (".config/nyxt/bookmarks.lisp" ,(local-file "./nyxt/bookmarks.lisp"))))

