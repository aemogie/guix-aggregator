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

(define-module (sss dconf)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss prelude)
  #:export (mk-dconf-writer-commands flatten-dconf-settings
                                     mk-nested-dconf-writer-commands
                                     sss-dconf-settings sss-dconf-capability))

(define (mk-dconf-writer-commands x)
  (format #f
          "echo \"~a --> ~a\" && dconf write \"~a\" \"~a\""
          (car x)
          (cdr x)
          (car x)
          (cdr x)))

(define (flatten-dconf-settings xs)
  (map (lambda (p)
         (append (map (lambda (pp)
                        (cons (format #f "~a/~a"
                                      (car p)
                                      (car pp))
                              (cdr pp)))
                      (cdr p)))) xs))

(define (mk-nested-dconf-writer-commands xs)
  (map mk-dconf-writer-commands
       (apply append
              (flatten-dconf-settings xs))))

(define* (sss-dconf-settings #:key lang
                             timezone
                             keyboard-layout
                             caps-to-ctrl?
                             hostname
                             clone-dir
                             palette
                             sans-font
                             serif-font
                             mono-font
                             brightness-timeout-seconds
                             lock-screen-seconds
                             monitor-power-seconds)
  `(("/sss" (lang unquote
                  (format #f "'~a'" lang))
     (timezone unquote
               (format #f "'~a'" timezone))
     (caps-to-ctrl unquote
                   (if caps-to-ctrl? "true" "false"))
     (hostname unquote
               (format #f "'~a'" hostname))
     (clone-dir unquote
                (format #f "'~a'" clone-dir))
     (palette unquote
              (format #f "'~a'" palette))
     (sans-font unquote
                (format #f "'~a'" sans-font))
     (serif-font unquote
                 (format #f "'~a'" serif-font))
     (mono-font unquote
                (format #f "'~a'" mono-font))
     (brightness-timeout-seconds unquote brightness-timeout-seconds)
     (lock-screen-seconds unquote lock-screen-seconds)
     (monitor-power-seconds unquote monitor-power-seconds))))

(define* (sss-dconf-capability #:key lang
                               timezone
                               keyboard-layout
                               caps-to-ctrl?
                               hostname
                               clone-dir
                               palette
                               sans-font
                               serif-font
                               mono-font
                               brightness-timeout-seconds
                               lock-screen-seconds
                               monitor-power-seconds)
  `((".local/bin/write-sss-dconf-settings.sh" ,(plain-file
                                                "write-sss-dconf-settings.sh"
                                                (string-join (append `("#!/usr/bin/env sh"
                                                                       ""
                                                                       "# ====== SSS settings dconf writer ======"
                                                                       "#"
                                                                       "# auto-generated file, DO NOT EDIT!"
                                                                       "")
                                                                     (mk-nested-dconf-writer-commands
                                                                      (sss-dconf-settings
                                                                       #:lang
                                                                       lang
                                                                       #:timezone
                                                                       timezone
                                                                       #:keyboard-layout
                                                                       keyboard-layout
                                                                       #:caps-to-ctrl?
                                                                       caps-to-ctrl?
                                                                       #:hostname
                                                                       hostname
                                                                       #:clone-dir
                                                                       clone-dir
                                                                       #:palette
                                                                       palette
                                                                       #:sans-font
                                                                       sans-font
                                                                       #:serif-font
                                                                       serif-font
                                                                       #:mono-font
                                                                       mono-font
                                                                       #:brightness-timeout-seconds
                                                                       brightness-timeout-seconds
                                                                       #:lock-screen-seconds
                                                                       lock-screen-seconds
                                                                       #:monitor-power-seconds
                                                                       monitor-power-seconds)))
                                                             "\n")))))
