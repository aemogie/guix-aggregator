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

(define-module (sss palette)
  #:use-module (gnu)
  #:use-module (ice-9 match)
  #:use-module (ice-9 exceptions)
  #:use-module (srfi srfi-64))

(define-public (sss-get-color palette sym)
  (match palette
    ('sss-palette-ef-bio (cdr (assoc sym sss-palette-ef-bio)))
    ('sss-palette-ef-dream (cdr (assoc sym sss-palette-ef-dream)))
    ('sss-palette-heavy-metal (cdr (assoc sym sss-palette-heavy-metal)))
    ('sss-palette-ef-cyprus (cdr (assoc sym sss-palette-ef-cyprus)))
    ('sss-palette-ef-autumn (cdr (assoc sym sss-palette-ef-autumn)))
    ('sss-palette-solarized-light (cdr (assoc sym sss-palette-solarized-light)))
    ('sss-palette-everforest-light (cdr (assoc sym
                                               sss-palette-everforest-light)))
    ('sss-palette-everforest-dark (cdr (assoc sym sss-palette-everforest-dark)))
    (_ (raise-exception (make-exception-with-message (format #f
                                                      "exception ocurred! unknown palette selected: ~a"
                                                      palette))))))

(begin
  (define (hex-to-decimal n)
    (string->number (string-append "#x" n)))
  (define* (sss-hex-to-rgba hex
                            #:key (alpha 1))
    (let* ((digits (string-drop hex 1))
           (red (hex-to-decimal (string-take digits 2)))
           (green (hex-to-decimal (string-take (string-drop digits 2) 2)))
           (blue (hex-to-decimal (string-drop digits 4))))
      (format #f
              "rgba(~a, ~a, ~a, ~a)"
              red
              green
              blue
              alpha)))
  (export sss-hex-to-rgba))

(define-public sss-palette-ef-dream
  `((primary . "#675072") (primary-l . "#b0a0cf")
    (text . "#efd5c5")
    (text-l . "#dec4b4")
    (background . "#232025")
    (background-l . "#322f34")))

(define-public sss-palette-ef-bio
  `((primary . "#00552f") (primary-l . "#3fb83f")
    (text . "#dfefe6")
    (text-l . "#cfdfd5")
    (background . "#111111")
    (background-l . "#222522")))

(define-public sss-palette-ef-cyprus
  `((primary . "#b3d19d") (primary-l . "#c4f2af")
    (text . "#242521")
    (text-l . "#353632")
    (background . "#fcf7ef")
    (background-l . "#f0ece0")))

(define-public sss-palette-ef-autumn
  `((primary . "#7a3b23") (primary-l . "#c0620e")
    (text . "#dfcdcb")
    (text-l . "#cfbcba")
    (background . "#26211d")
    (background-l . "#36322f")))

(define-public sss-palette-solarized-light
  `((primary . "#f9a25a") (primary-l . "#e89149")
    (text . "#142a31")
    (text-l . "#253b42")
    (background . "#fdf6e3")
    (background-l . "#eee8d5")))

(define-public sss-palette-heavy-metal
  `((primary . "#b02930") (primary-l . "#f47360")
    (text . "#ffe6d6")
    (text-l . "#efd5c5")
    (background . "#111111")
    (background-l . "#222522")))

(define-public sss-palette-everforest-dark
  `((primary . "#a7c080") (primary-l . "#b8d191")
    (text . "#d3c6aa")
    (text-l . "#e4d7bb")
    (background . "#272e33")
    (background-l . "#1e2326")))

(define-public sss-palette-everforest-light
  `((primary . "#a7c080") (primary-l . "#b8d191")
    (text . "#272e33")
    (text-l . "#383f44")
    (background . "#fffbef")
    (background-l . "#eeeade")))

(test-begin "sss-palette tests")

;; Test color retrieval
(test-equal "Retrieve primary color from ef-dream palette" "#675072"
            (sss-get-color 'sss-palette-ef-dream
                           'primary))

(test-equal "Retrieve text color from ef-bio palette" "#dfefe6"
            (sss-get-color 'sss-palette-ef-bio
                           'text))

(test-error (sss-get-color 'unknown-palette
                           'primary))

;; Test sss-hex-to-rgba conversion
(test-equal "Convert hex #ff5733 to rgba" "rgba(255, 87, 51, 1)"
            (sss-hex-to-rgba "#ff5733"))

(test-equal "Convert hex #008080 to rgba with alpha 0.5"
            "rgba(0, 128, 128, 0.5)"
            (sss-hex-to-rgba "#008080"
                             #:alpha 0.5))

(test-end)
