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

(load "./palette.scm")
(load "./process.scm")

(define-module (sss gtk)
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss process))

(begin
  (define* (sss-gtk3-config #:key palette
                            (fixed-theme #f)
                            (fixed-icon-theme #f))
    `((gtk-icon-theme-name unquote
                           (cond
                             ((not (equal? #f fixed-icon-theme))
                              fixed-icon-theme)
                             ((equal? 'sss-palette-ef-cyprus palette)
                              "Yaru-sage")
                             ((equal? 'sss-palette-ef-autumn palette)
                              "Yaru-dark")
                             ((equal? 'sss-palette-heavy-metal palette)
                              "Yaru-red-dark")
                             ((equal? 'sss-palette-ef-dream palette)
                              "Yaru-magenta-dark")
                             ((equal? 'sss-palette-solarized-light palette)
                              "Yaru")
                             ((equal? 'sss-palette-everforest-light palette)
                              "Yaru-sage")
                             (else "Yaru-sage-dark")))
      (gtk-theme-name unquote
                      (cond
                        ((not (equal? #f fixed-theme))
                         fixed-theme)
                        ((equal? 'sss-palette-ef-cyprus palette)
                         "Yaru-sage")
                        ((equal? 'sss-palette-heavy-metal palette)
                         "Yaru-red-dark")
                        ((equal? 'sss-palette-ef-autumn palette)
                         "Yaru-dark")
                        ((equal? 'sss-palette-ef-dream palette)
                         "Yaru-magenta-dark")
                        ((equal? 'sss-palette-solarized-light palette)
                         "Yaru")
                        ((equal? 'sss-palette-everforest-light palette)
                         "Yaru-sage")
                        (else "Yaru-sage-dark")))
      (gtk-font-name . "Inter 11")
      (gtk-key-theme-name . "Emacs")
      (gtk-enable-event-sounds . 0)
      (gtk-cursor-theme-name . "Yaru")
      (gtk-cursor-theme-size . 24)
      (gtk-enable-input-feedback-sounds . 0)
      (gtk-application-prefer-dark-theme unquote
                                         (cond
                                           ((equal? 'sss-palette-ef-cyprus
                                                    palette)
                                            0)
                                           ((equal? 'sss-palette-ef-dream
                                                    palette)
                                            1)
                                           ((equal? 'sss-palette-solarized-light
                                                    palette)
                                            0)
                                           ((equal? 'sss-palette-everforest-light
                                                    palette)
                                            0)
                                           (else 1)))))
  (export sss-gtk3-config))

(begin
  (define* (sss-gtk4-config #:key palette
                            (fixed-theme #f)
                            (fixed-icon-theme #f))
    `((gtk-icon-theme-name unquote
                           (cond
                             ((not (equal? #f fixed-icon-theme))
                              fixed-icon-theme)
                             ((equal? 'sss-palette-ef-cyprus palette)
                              "Yaru-sage")
                             ((equal? 'sss-palette-heavy-metal palette)
                              "Yaru-red-dark")
                             ((equal? 'sss-palette-ef-autumn palette)
                              "Yaru-dark")
                             ((equal? 'sss-palette-ef-dream palette)
                              "Yaru-magenta-dark")
                             ((equal? 'sss-palette-solarized-light palette)
                              "Yaru")
                             ((equal? 'sss-palette-everforest-light palette)
                              "Yaru-sage")
                             (else "Yaru-sage-dark")))
      (gtk-theme-name unquote
                      (cond
                        ((not (equal? #f fixed-theme))
                         fixed-theme)
                        ((equal? 'sss-palette-ef-cyprus palette)
                         "Yaru-sage")
                        ((equal? 'sss-palette-heavy-metal palette)
                         "Yaru-red-dark")
                        ((equal? 'sss-palette-ef-autumn palette)
                         "Yaru-dark")
                        ((equal? 'sss-palette-ef-dream palette)
                         "Yaru-magenta-dark")
                        ((equal? 'sss-palette-solarized-light palette)
                         "Yaru")
                        ((equal? 'sss-palette-everforest-light palette)
                         "Yaru-sage")
                        (else "Yaru-sage-dark")))
      (gtk-font-name . "Inter 11")
      (gtk-enable-event-sounds . 0)
      (gtk-cursor-theme-name . "Yaru")
      (gtk-cursor-theme-size . 24)
      (gtk-enable-input-feedback-sounds . 0)
      (gtk-application-prefer-dark-theme unquote
                                         (cond
                                           ((equal? 'sss-palette-ef-cyprus
                                                    palette)
                                            0)
                                           ((equal? 'sss-palette-ef-dream
                                                    palette)
                                            1)
                                           ((equal? 'sss-palette-solarized-light
                                                    palette)
                                            0)
                                           ((equal? 'sss-palette-everforest-light
                                                    palette)
                                            0)
                                           (else 1)))))
  (export sss-gtk4-config))

(begin
  (define* (sss-gtk3-svc #:key palette)
    `((".config/gtk-3.0/settings.ini" ,(plain-file "settings.ini"
                                                   (string-append
                                                    "[Settings]\n"
                                                    (mk-kv-conf-lines (sss-gtk3-config
                                                                       #:palette
                                                                       palette)))))))
  (export sss-gtk3-svc))

(begin
  (define* (sss-gtk4-svc #:key palette)
    `((".config/gtk-4.0/settings.ini" ,(plain-file "settings.ini"
                                                   (string-append
                                                    "[Settings]\n"
                                                    (mk-kv-conf-lines (sss-gtk4-config
                                                                       #:palette
                                                                       palette)))))))
  (export sss-gtk4-svc))
