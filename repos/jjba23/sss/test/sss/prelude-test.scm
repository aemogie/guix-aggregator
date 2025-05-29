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

(define-module (sss prelude-test)
  #:use-module ((srfi srfi-64)
                #:hide (define-test))
  #:use-module (sss test-utils)
  #:use-module (sss prelude))

(define-test test-prelude
             (test-group "prelude"
                         (test-assert (log-exprs 42 "supreme-sexp-system"
                                                 (+ 2 2)
                                                 (string-upcase "hello world")
                                                 (length '(1 2 3))))
                         (test-equal #f
                                     (or (equal? ""
                                                 (get-setting 'lang))
                                         (equal? #f
                                                 (get-setting 'lang))))
                         (test-equal "ello worl"
                                     (string-drop-first-last-n "hello world" 1))
                         (test-equal "e"
                                     (string-drop-first-last-n "hey" 1))
                         (test-equal "h"
                                     (string-drop-first-last-n "h" 1))
                         (test-equal "reme sexp sys"
                                     (string-drop-first-last-n
                                      "supreme sexp system" 3))))

