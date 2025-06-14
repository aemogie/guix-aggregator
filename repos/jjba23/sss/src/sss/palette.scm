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
  #:use-module (ice-9 exceptions)
  #:export (raise-unknown-palette-exception get-color
                                            get-gtk-theme
                                            is-dark-palette
                                            get-icon-theme
                                            get-emacs-theme
                                            get-fish-color
                                            get-cursor-theme
                                            ansi-color-escapes
                                            get-ansi-color
                                            hex-to-decimal
                                            hex-to-rgba
                                            everforest-light
                                            everforest-dark
                                            heavy-metal
                                            solarized-light
                                            ef-autumn
                                            ef-cyprus
                                            ef-bio
                                            ef-dream
                                            gruvbox-dark
                                            gruvbox-light))

(define (raise-unknown-palette-exception palette)
  (raise-exception (make-exception-with-message (format #f
                                                 "exception ocurred! unknown palette selected: ~a"
                                                 palette))))

(define-syntax-rule (get-color palette sym)
  (match palette
    ('ef-bio (cdr (assoc sym ef-bio)))
    ('ef-dream (cdr (assoc sym ef-dream)))
    ('heavy-metal (cdr (assoc sym heavy-metal)))
    ('ef-cyprus (cdr (assoc sym ef-cyprus)))
    ('ef-autumn (cdr (assoc sym ef-autumn)))
    ('solarized-light (cdr (assoc sym solarized-light)))
    ('everforest-light (cdr (assoc sym everforest-light)))
    ('everforest-dark (cdr (assoc sym everforest-dark)))
    ('gruvbox-light (cdr (assoc sym gruvbox-light)))
    ('gruvbox-dark (cdr (assoc sym gruvbox-dark)))
    (_ (raise-unknown-palette-exception palette))))

(define-syntax-rule (get-gtk-theme palette)
  (match palette
    ('ef-bio "Yaru-sage-dark")
    ('ef-dream "Yaru-magenta-dark")
    ('heavy-metal "Yaru-red-dark")
    ('ef-cyprus "Yaru-sage")
    ('ef-autumn "Yaru-dark")
    ('solarized-light "Yaru")
    ('everforest-light "Yaru-sage")
    ('everforest-dark "Yaru-sage-dark")
    ('gruvbox-light "Yaru")
    ('gruvbox-dark "Yaru-dark")
    (_ (raise-unknown-palette-exception palette))))

(define-syntax-rule (is-dark-palette palette)
  (match palette
    ('ef-bio #t)
    ('ef-dream #t)
    ('heavy-metal #t)
    ('ef-cyprus #f)
    ('ef-autumn #t)
    ('solarized-light #f)
    ('everforest-light #f)
    ('everforest-dark #t)
    ('gruvbox-light #f)
    ('gruvbox-dark #t)
    (_ (raise-unknown-palette-exception palette))))

(define-syntax-rule (get-icon-theme palette)
  (match palette
    ('ef-bio "Yaru-sage-dark")
    ('ef-dream "Yaru-magenta-dark")
    ('heavy-metal "Yaru-red-dark")
    ('ef-cyprus "Yaru-sage")
    ('ef-autumn "Yaru-dark")
    ('solarized-light "Yaru")
    ('everforest-light "Yaru-sage")
    ('everforest-dark "Yaru-sage-dark")
    ('gruvbox-light "Yaru")
    ('gruvbox-dark "Yaru-dark")
    (_ (raise-unknown-palette-exception palette))))

(define-syntax-rule (get-emacs-theme palette)
  (match palette
    ('ef-bio "'ef-bio")
    ('ef-dream "'ef-dream")
    ('heavy-metal "'ef-tritanopia-dark")
    ('ef-cyprus "'ef-cyprus")
    ('ef-autumn "'ef-autumn")
    ('solarized-light "'solarized-light")
    ('everforest-light "'everforest-hard-light")
    ('everforest-dark "'everforest-hard-dark")
    ('gruvbox-light "'gruvbox-light-hard")
    ('gruvbox-dark "'gruvbox-dark-hard")
    (_ (raise-unknown-palette-exception palette))))

(define-syntax-rule (get-fish-color palette)
  (match palette
    ('ef-bio 'green)
    ('ef-dream 'magenta)
    ('heavy-metal 'red)
    ('ef-cyprus 'green)
    ('ef-autumn 'yellow)
    ('solarized-light 'black)
    ('everforest-light 'black)
    ('everforest-dark 'green)
    ('gruvbox-light 'black)
    ('gruvbox-dark 'orange)
    (_ (raise-unknown-palette-exception palette))))

(define-syntax-rule (get-cursor-theme palette)
  (match palette
    ('ef-bio "Yaru")
    ('ef-dream "Yaru")
    ('heavy-metal "Yaru")
    ('ef-cyprus "Yaru")
    ('ef-autumn "Yaru")
    ('solarized-light "Yaru")
    ('everforest-light "Yaru")
    ('everforest-dark "Yaru")
    ('gruvbox-light "Yaru")
    ('gruvbox-dark "Yaru")
    (_ (raise-unknown-palette-exception palette))))

(define-syntax-rule (get-ansi-color palette)
  (match palette
    ('ef-bio (assoc-ref ansi-color-escapes
                        'green))
    ('ef-dream (assoc-ref ansi-color-escapes
                          'magenta))
    ('heavy-metal (assoc-ref ansi-color-escapes
                             'red))
    ('ef-cyprus (assoc-ref ansi-color-escapes
                           'green))
    ('ef-autumn (assoc-ref ansi-color-escapes
                           'yellow))
    ('solarized-light (assoc-ref ansi-color-escapes
                                 'default))
    ('everforest-light (assoc-ref ansi-color-escapes
                                  'default))
    ('everforest-dark (assoc-ref ansi-color-escapes
                                 'green))
    ('gruvbox-light (assoc-ref ansi-color-escapes
                               'default))
    ('gruvbox-dark (assoc-ref ansi-color-escapes
                              'yellow))
    (_ (raise-unknown-palette-exception palette))))

(define-syntax-rule (hex-to-decimal n)
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

(define ansi-color-escapes
  `((yellow . "\x1b[0;33m") (magenta . "\x1b[0;35m")
    (green . "\x1b[0;32m")
    (default . "\x1b[0;39m")
    (red . "\x1b[0;31m")
    (blue . "\x1b[0;34m")
    (cyan . "\x1b[0;36m")
    (reset . "\x1b[0m")))

(define ef-dream
  `((primary . "#675072") (primary-l . "#b0a0cf")
    (text . "#efd5c5")
    (text-l . "#dec4b4")
    (background . "#232025")
    (background-l . "#322f34")))

(define ef-bio
  `((primary . "#00552f") (primary-l . "#3fb83f")
    (text . "#dfefe6")
    (text-l . "#cfdfd5")
    (background . "#111111")
    (background-l . "#222522")))

(define ef-cyprus
  `((primary . "#b3d19d") (primary-l . "#c4f2af")
    (text . "#242521")
    (text-l . "#353632")
    (background . "#fcf7ef")
    (background-l . "#f0ece0")))

(define ef-autumn
  `((primary . "#7a3b23") (primary-l . "#c0620e")
    (text . "#dfcdcb")
    (text-l . "#cfbcba")
    (background . "#26211d")
    (background-l . "#36322f")))

(define solarized-light
  `((primary . "#f9a25a") (primary-l . "#e89149")
    (text . "#142a31")
    (text-l . "#253b42")
    (background . "#fdf6e3")
    (background-l . "#eee8d5")))

(define heavy-metal
  `((primary . "#b02930") (primary-l . "#f47360")
    (text . "#ffe6d6")
    (text-l . "#efd5c5")
    (background . "#111111")
    (background-l . "#222522")))

(define everforest-dark
  `((primary . "#a7c080") (primary-l . "#b8d191")
    (text . "#d3c6aa")
    (text-l . "#e4d7bb")
    (background . "#272e33")
    (background-l . "#1e2326")))

(define everforest-light
  `((primary . "#a7c080") (primary-l . "#b8d191")
    (text . "#272e33")
    (text-l . "#383f44")
    (background . "#fffbef")
    (background-l . "#eeeade")))

(define gruvbox-dark
  `((primary . "#fe8019") (primary-l . "#d65d0e")
    (text . "#ebdbb2")
    (text-l . "#fbf1c7")
    (background . "#1d2021")
    (background-l . "#282828")))

(define gruvbox-light
  `((primary . "#d65d0e") (primary-l . "#d75f00")
    (text . "#1d2021")
    (text-l . "#282828")
    (background . "#ebdbb2")
    (background-l . "#fbf1c7")))
