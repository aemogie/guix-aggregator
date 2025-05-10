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
  (define* (sss-gtk3-config #:key palette)
    `((gtk-icon-theme-name unquote
                           (sss-get-icon-theme palette))
      (gtk-theme-name unquote
                      (sss-get-gtk-theme palette))
      (gtk-font-name . "Adwaita Sans 11")
      (gtk-key-theme-name . Emacs)
      (gtk-enable-event-sounds . 0)
      (gtk-cursor-theme-name unquote
                             (sss-get-cursor-theme palette))
      (gtk-cursor-theme-size . 24)
      (gtk-enable-input-feedback-sounds . 0)
      (gtk-application-prefer-dark-theme unquote
                                         (if (sss-is-dark-palette palette) 1 0))))
  (export sss-gtk3-config))

(begin
  (define* (sss-gtk4-config #:key palette)
    `((gtk-icon-theme-name unquote
                           (sss-get-icon-theme palette))
      (gtk-theme-name unquote
                      (sss-get-gtk-theme palette))
      (gtk-font-name . "Adwaita Sans 11")
      (gtk-key-theme-name . Emacs)
      (gtk-enable-event-sounds . 0)
      (gtk-cursor-theme-name unquote
                             (sss-get-cursor-theme palette))
      (gtk-cursor-theme-size . 24)
      (gtk-enable-input-feedback-sounds . 0)
      (gtk-application-prefer-dark-theme unquote
                                         (if (sss-is-dark-palette palette) 1 0))))
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
