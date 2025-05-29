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

(define-module (sss palette-test)
  #:use-module ((srfi srfi-64)
                #:hide (define-test))
  #:use-module (sss test-utils)
  #:use-module (sss palette))

(define-test test-palette
             (test-group "palette"
                         (test-equal
                          "Retrieve primary color from ef-dream palette" "#"
                          (string-take (get-color 'ef-dream
                                                  'primary) 1))

                         (test-equal "Retrieve text color from ef-bio palette"
                          "#"
                          (string-take (get-color 'ef-bio
                                                  'text) 1))

                         (test-error (get-color 'unknown-palette
                                                'primary))

                         (test-equal "Convert hex #ff5733 to rgba"
                                     "rgba(255, 87, 51, 1)"
                                     (hex-to-rgba "#ff5733"))
                         (test-equal "Convert hex #000000 to rgba"
                                     "rgba(0, 0, 0, 1)"
                                     (hex-to-rgba "#000000"))
                         (test-equal "Convert hex #ffffff to rgba"
                                     "rgba(255, 255, 255, 1)"
                                     (hex-to-rgba "#ffffff"))

                         (test-equal
                          "Convert hex #008080 to rgba with alpha 0.5"
                          "rgba(0, 128, 128, 0.5)"
                          (hex-to-rgba "#008080"
                                       #:alpha 0.5))
                         (test-equal
                          "Getting an ANSI color for a palette works" #t
                          (not (equal? ""
                                       (get-ansi-color 'ef-dream))))))
