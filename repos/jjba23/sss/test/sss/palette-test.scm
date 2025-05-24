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

(define-test test-hyprlang
             (test-group "palette"
                         ;; Test color retrieval
                         (test-equal
                          "Retrieve primary color from ef-dream palette"
                          "#675072"
                          (sss-get-color 'sss-palette-ef-dream
                                         'primary))

                         (test-equal "Retrieve text color from ef-bio palette"
                          "#dfefe6"
                          (sss-get-color 'sss-palette-ef-bio
                                         'text))

                         (test-error (sss-get-color 'unknown-palette
                                                    'primary))

                         ;; Test sss-hex-to-rgba conversion
                         (test-equal "Convert hex #ff5733 to rgba"
                                     "rgba(255, 87, 51, 1)"
                                     (sss-hex-to-rgba "#ff5733"))

                         (test-equal
                          "Convert hex #008080 to rgba with alpha 0.5"
                          "rgba(0, 128, 128, 0.5)"
                          (sss-hex-to-rgba "#008080"
                                           #:alpha 0.5))))
