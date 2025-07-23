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

(define-module (veritas unit palette-spec)
  #:use-module (veritas veritas)
  #:use-module (sss palette)
  #:export (spec))

(define palette-suite
  (suite "Palette test suite"
         (test "get-color"
               (assert-equal #:expected "#"
                             #:sut (string-take (get-color 'ef-bio
                                                           'text) 1))
               (assert-error (lambda ()
                               (get-color 'unknown-palette
                                          'primary))))
         (test "hex-to-rgba"
               (assert-equal #:expected "rgba(255, 87, 51, 1)"
                             #:sut (hex-to-rgba "#ff5733"))
               (assert-equal #:expected "rgba(0, 0, 0, 1)"
                             #:sut (hex-to-rgba "#000000"))
               (assert-equal #:expected "rgba(255, 255, 255, 1)"
                             #:sut (hex-to-rgba "#ffffff"))
               (assert-equal #:expected "rgba(0, 128, 128, 0.5)"
                             #:sut (hex-to-rgba "#008080"
                                                #:alpha 0.5)))
         (test "get-ansi-color"
               (assert-true (not (equal? ""
                                         (get-ansi-color 'ef-dream)))))))

(define (spec)
  (veritas-run palette-suite))
