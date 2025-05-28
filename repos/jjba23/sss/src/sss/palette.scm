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
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (ice-9 match)
  #:use-module (ice-9 exceptions))

(define-public (raise-unknown-palette-exception palette)
  (raise-exception (make-exception-with-message (format #f
                                                 "exception ocurred! unknown palette selected: ~a"
                                                 palette))))

(define-public (get-color palette sym)
  (match palette
    ('ef-bio (cdr (assoc sym ef-bio)))
    ('ef-dream (cdr (assoc sym ef-dream)))
    ('heavy-metal (cdr (assoc sym heavy-metal)))
    ('ef-cyprus (cdr (assoc sym ef-cyprus)))
    ('ef-autumn (cdr (assoc sym ef-autumn)))
    ('solarized-light (cdr (assoc sym solarized-light)))
    ('everforest-light (cdr (assoc sym everforest-light)))
    ('everforest-dark (cdr (assoc sym everforest-dark)))
    (_ (raise-unknown-palette-exception palette))))

(define-public (get-gtk-theme palette)
  (match palette
    ('ef-bio "Yaru-sage-dark")
    ('ef-dream "Yaru-magenta-dark")
    ('heavy-metal "Yaru-red-dark")
    ('ef-cyprus "Yaru-sage")
    ('ef-autumn "Yaru-dark")
    ('solarized-light "Yaru")
    ('everforest-light "Yaru-sage")
    ('everforest-dark "Yaru-sage-dark")
    (_ (raise-unknown-palette-exception palette))))

(define-public (is-dark-palette palette)
  (match palette
    ('ef-bio #t)
    ('ef-dream #t)
    ('heavy-metal #t)
    ('ef-cyprus #f)
    ('ef-autumn #t)
    ('solarized-light #f)
    ('everforest-light #f)
    ('everforest-dark #t)
    (_ (raise-unknown-palette-exception palette))))

(define-public (get-icon-theme palette)
  (match palette
    ('ef-bio "Yaru-sage-dark")
    ('ef-dream "Yaru-magenta-dark")
    ('heavy-metal "Yaru-red-dark")
    ('ef-cyprus "Yaru-sage")
    ('ef-autumn "Yaru-dark")
    ('solarized-light "Yaru")
    ('everforest-light "Yaru-sage")
    ('everforest-dark "Yaru-sage-dark")
    (_ (raise-unknown-palette-exception palette))))

(define-public (get-emacs-theme palette)
  (match palette
    ('ef-bio "'ef-bio")
    ('ef-dream "'ef-dream")
    ('heavy-metal "'ef-tritanopia-dark")
    ('ef-cyprus "'ef-cyprus")
    ('ef-autumn "'ef-autumn")
    ('solarized-light "'solarized-light")
    ('everforest-light "'everforest-hard-light")
    ('everforest-dark "'everforest-hard-dark")
    (_ (raise-unknown-palette-exception palette))))

(define-public (sss-get-cursor-theme palette)
  (match palette
    ('ef-bio "Yaru")
    ('ef-dream "Yaru")
    ('heavy-metal "Yaru")
    ('ef-cyprus "Yaru")
    ('ef-autumn "Yaru")
    ('solarized-light "Yaru")
    ('everforest-light "Yaru")
    ('everforest-dark "Yaru")
    (_ (raise-unknown-palette-exception palette))))

(begin
  (define (hex-to-decimal n)
    (string->number (string-append "#x" n)))
  (define* (hex-to-rgba hex
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
  (export hex-to-rgba))

(define-public ef-dream
  `((primary . "#675072") (primary-l . "#b0a0cf")
    (text . "#efd5c5")
    (text-l . "#dec4b4")
    (background . "#232025")
    (background-l . "#322f34")))

(define-public ef-bio
  `((primary . "#00552f") (primary-l . "#3fb83f")
    (text . "#dfefe6")
    (text-l . "#cfdfd5")
    (background . "#111111")
    (background-l . "#222522")))

(define-public ef-cyprus
  `((primary . "#b3d19d") (primary-l . "#c4f2af")
    (text . "#242521")
    (text-l . "#353632")
    (background . "#fcf7ef")
    (background-l . "#f0ece0")))

(define-public ef-autumn
  `((primary . "#7a3b23") (primary-l . "#c0620e")
    (text . "#dfcdcb")
    (text-l . "#cfbcba")
    (background . "#26211d")
    (background-l . "#36322f")))

(define-public solarized-light
  `((primary . "#f9a25a") (primary-l . "#e89149")
    (text . "#142a31")
    (text-l . "#253b42")
    (background . "#fdf6e3")
    (background-l . "#eee8d5")))

(define-public heavy-metal
  `((primary . "#b02930") (primary-l . "#f47360")
    (text . "#ffe6d6")
    (text-l . "#efd5c5")
    (background . "#111111")
    (background-l . "#222522")))

(define-public everforest-dark
  `((primary . "#a7c080") (primary-l . "#b8d191")
    (text . "#d3c6aa")
    (text-l . "#e4d7bb")
    (background . "#272e33")
    (background-l . "#1e2326")))

(define-public everforest-light
  `((primary . "#a7c080") (primary-l . "#b8d191")
    (text . "#272e33")
    (text-l . "#383f44")
    (background . "#fffbef")
    (background-l . "#eeeade")))

