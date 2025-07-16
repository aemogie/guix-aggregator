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

(define-module (sss dconf)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss prelude)
  #:export (mk-dconf-writer-commands flatten-dconf-settings
                                     mk-nested-dconf-writer-commands))

(define (mk-dconf-writer-commands x)
  (format #f
          "echo \"~a --> ~a\" && dconf write \"~a\" \"~a\""
          (car x)
          (cdr x)
          (car x)
          (cdr x)))

(define (flatten-dconf-settings xs)
  (map (lambda (p)
         (append (map (lambda (pp)
                        (cons (format #f "~a/~a"
                                      (car p)
                                      (car pp))
                              (cdr pp)))
                      (cdr p)))) xs))

(define (mk-nested-dconf-writer-commands xs)
  (map mk-dconf-writer-commands
       (apply append
              (flatten-dconf-settings xs))))

