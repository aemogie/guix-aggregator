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

(define-module (sss mako)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss process)
  #:export (mako-config mako-capability))

(define* (mako-config #:key palette sans-font)
  `((sort . "-time") (max-history . 7)
    (on-button-left . dismiss)
    (on-button-right . invoke-default-action)
    (background-color unquote
                      (string-upcase (format #f "~abb"
                                             (get-color palette
                                                        'background))))
    (border-color unquote
                  (string-upcase (format #f "~abb"
                                         (get-color palette
                                                    'primary))))
    (text-color unquote
                (string-upcase (format #f "~abb"
                                       (get-color palette
                                                  'text))))
    (font unquote
          (format #f "~a 11" sans-font))
    (width . 420)
    (icons . 1)
    (default-timeout . 10000)
    (ignore-timeout . 1)
    (border-radius . 10)))

(define* (mako-capability #:key palette sans-font)
  `((".config/mako/config" ,(plain-file "config"
                                        (mk-kv-conf-lines (mako-config
                                                           #:palette palette
                                                           #:sans-font
                                                           sans-font))))))

