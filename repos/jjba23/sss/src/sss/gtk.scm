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

(define-module (sss gtk)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss prelude)
  #:export (gtk3-config gtk4-config gtk3-capability gtk4-capability))

(define* (gtk3-config #:key palette sans-font)
  `((gtk-icon-theme-name unquote
                         (get-icon-theme palette))
    (gtk-theme-name unquote
                    (get-gtk-theme palette))
    (gtk-font-name unquote
                   (format #f "~a 11" sans-font))
    (gtk-key-theme-name . Emacs)
    (gtk-enable-event-sounds . 0)
    (gtk-cursor-theme-name unquote
                           (get-cursor-theme palette))
    (gtk-cursor-theme-size . 24)
    (gtk-enable-input-feedback-sounds . 0)
    (gtk-application-prefer-dark-theme unquote
                                       (if (is-dark-palette palette) 1 0))))

(define* (gtk4-config #:key palette sans-font)
  `((gtk-icon-theme-name unquote
                         (get-icon-theme palette))
    (gtk-theme-name unquote
                    (get-gtk-theme palette))
    (gtk-font-name unquote
                   (format #f "~a 11" sans-font))
    (gtk-key-theme-name . Emacs)
    (gtk-enable-event-sounds . 0)
    (gtk-cursor-theme-name unquote
                           (get-cursor-theme palette))
    (gtk-cursor-theme-size . 24)
    (gtk-enable-input-feedback-sounds . 0)
    (gtk-application-prefer-dark-theme unquote
                                       (if (is-dark-palette palette) 1 0))))

(define* (gtk3-capability #:key palette sans-font)
  `((".config/gtk-3.0/settings.ini" ,(plain-file "settings.ini"
                                                 (string-append "[Settings]\n"
                                                                (mk-kv-conf-lines
                                                                 (gtk3-config
                                                                  #:palette
                                                                  palette
                                                                  #:sans-font
                                                                  sans-font)))))))

(define* (gtk4-capability #:key palette sans-font)
  `((".config/gtk-4.0/settings.ini" ,(plain-file "settings.ini"
                                                 (string-append "[Settings]\n"
                                                                (mk-kv-conf-lines
                                                                 (gtk4-config
                                                                  #:palette
                                                                  palette
                                                                  #:sans-font
                                                                  sans-font)))))))

