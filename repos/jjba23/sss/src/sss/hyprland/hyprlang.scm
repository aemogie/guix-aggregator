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

(define-module (sss hyprland hyprlang)
  #:declarative? #t
  #:export (serialize-hypr-setting serialize-hypr-section
                                   hypr-translate-mod
                                   hypr-translate-bind
                                   hypr-bind
                                   exec-bind
                                   special-bind
                                   hypr-window-rule))

(define* (serialize-hypr-setting type setting
                                 #:key (indent "")
                                 (nested #f))
  (if nested
      (format #f
              "~a~a~a = ~a"
              indent
              indent
              type
              setting)
      (format #f "~a~a = ~a" indent type setting)))

(define* (serialize-hypr-section #:key section settings
                                 (indent "")
                                 (nested #f))
  (let ((xs (string-join (map (lambda (x)
                                (cond
                                  ((list? (cdr x))
                                   (serialize-hypr-section #:section (car x)
                                                           #:settings (cdr x)
                                                           #:indent "  "
                                                           #:nested #t))
                                  (else (serialize-hypr-setting (car x)
                                                                (cdr x)
                                                                #:indent "  "
                                                                #:nested
                                                                nested))))
                              settings) "\n")))
    (format #f
            "~a~a {\n~a\n~a}"
            indent
            section
            xs
            indent)))

(define (hypr-translate-mod mod)
  (cond
    ((equal? "s" mod)
     "SUPER")
    ((equal? "s-S" mod)
     "SUPER_SHIFT")
    ((equal? "M" mod)
     "ALT")
    (else mod)))

(define (hypr-translate-bind bind)
  (cond
    ((equal? "mouse-left" bind)
     "mouse:272")
    ((equal? "mouse-right" bind)
     "mouse:273")
    (else bind)))

(define* (hypr-bind #:key bind dispatch
                    (cmd "")
                    (mod ""))
  (format #f
          "~a, ~a, ~a, ~a"
          (hypr-translate-mod mod)
          (hypr-translate-bind bind)
          dispatch
          cmd))

(define* (exec-bind #:key bind
                    (cmd "")
                    (mod ""))
  (hypr-bind #:bind bind
             #:dispatch 'exec
             #:cmd cmd
             #:mod mod))

(define* (special-bind #:key bind dispatch
                       (mod ""))
  (format #f "~a, ~a, ~a"
          (hypr-translate-mod mod)
          (hypr-translate-bind bind) dispatch))

(define* (hypr-window-rule #:key action class)
  (format #f "~a, class:~a" action class))

