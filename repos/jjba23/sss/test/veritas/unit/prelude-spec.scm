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

(define-module (veritas unit prelude-spec)
  #:use-module (veritas veritas)
  #:use-module (sss prelude)
  #:export (spec))

(define prelude-suite
  (suite "Prelude test suite"
         (test "log-exprs does not raise errors"
               (assert-no-error (lambda ()
                                  (log-exprs 42 "supreme-sexp-system"
                                             (+ 2 2)
                                             (string-upcase "hello world")
                                             (length '(1 2 3))))))
         (test
          "get-setting used on an essential setting like 'lang always works"
          (assert-false (or (equal? ""
                                    (get-setting 'lang))
                            (equal? #f
                                    (get-setting 'lang)))))
         (test "string-drop-first-last-n"
               (assert-equal #:sut (string-drop-first-last-n "hello world" 1)
                             #:expected "ello worl")
               (assert-equal #:sut (string-drop-first-last-n "hey" 1)
                             #:expected "e")
               (assert-equal #:sut (string-drop-first-last-n "h" 1)
                             #:expected "h")
               (assert-equal #:sut (string-drop-first-last-n
                                    "supreme sexp system" 3)
                             #:expected "reme sexp sys"))))

(define (spec)
  (veritas-run prelude-suite))
