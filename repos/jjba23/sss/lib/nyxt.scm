;;; SSS - Supreme Sexp System

;; Copyright (C) 2025 - Josep Bigorra, jjba23 <jjbigorra@gmail.com>

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
  #:use-module (gnu)
  #:use-module (sss palette))

(begin
  (define* (sss-nyxt-svc)
    `((".config/nyxt/config.lisp" ,(local-file "./nyxt/config.lisp"))
      (".config/nyxt/bookmarks.lisp" ,(local-file "./nyxt/bookmarks.lisp"))))
  (export sss-nyxt-svc))
