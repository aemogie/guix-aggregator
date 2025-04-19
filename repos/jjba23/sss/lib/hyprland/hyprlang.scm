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
  #:use-module (srfi srfi-64))

(begin
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
  (export serialize-hypr-setting))

(begin
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
                                                                  #:indent
                                                                  "  "
                                                                  #:nested
                                                                  nested))))
                                settings) "\n")))
      (format #f
              "~a~a {\n~a\n~a}"
              indent
              section
              xs
              indent)))
  (export serialize-hypr-section))

(begin
  (define (hypr-translate-mod mod)
    (cond
      ((equal? "s" mod)
       "SUPER")
      ((equal? "s-S" mod)
       "SUPER_SHIFT")
      ((equal? "M" mod)
       "ALT")
      (else mod)))
  (export hypr-translate-mod))

(begin
  (define (hypr-translate-bind bind)
    (cond
      ((equal? "mouse-left" bind)
       "mouse:272")
      ((equal? "mouse-right" bind)
       "mouse:273")
      (else bind)))
  (export hypr-translate-bind))

(begin
  (define* (hypr-bind #:key bind dispatch
                      (cmd "")
                      (mod ""))
    (format #f
            "~a, ~a, ~a, ~a"
            (hypr-translate-mod mod)
            (hypr-translate-bind bind)
            dispatch
            cmd))
  (export hypr-bind))

(begin
  (define* (exec-bind #:key bind
                      (cmd "")
                      (mod ""))
    (hypr-bind #:bind bind
               #:dispatch 'exec
               #:cmd cmd
               #:mod mod))
  (export exec-bind))

(begin
  (define* (special-bind #:key bind dispatch
                         (mod ""))
    (format #f "~a, ~a, ~a"
            (hypr-translate-mod mod)
            (hypr-translate-bind bind) dispatch))
  (export special-bind))

(begin
  (define* (hypr-window-rule #:key action class)
    (format #f "~a, class:~a" action class))
  (export hypr-window-rule))

;; ====== module tests ======

(test-begin "hyprlang tests")

(test-equal "serialize-hypr-setting basic" "key = value"
            (serialize-hypr-setting "key" "value"))

(test-equal "serialize-hypr-setting with indent" "  key = value"
            (serialize-hypr-setting "key" "value"
                                    #:indent "  "))

(test-equal "serialize-hypr-setting nested" "    key = value"
            (serialize-hypr-setting "key"
                                    "value"
                                    #:indent "  "
                                    #:nested #t))

(test-equal "serialize-hypr-section basic" "section {\n  key = value\n}"
            (serialize-hypr-section #:section "section"
                                    #:settings '(("key" . "value"))))

(test-equal "serialize-hypr-section nested" "section {
  subsection {
    key = value
  }
}"
            (serialize-hypr-section #:section "section"
                                    #:settings '(("subsection"
                                                  ("key" . "value")))))

(test-equal "hypr-translate-mod SUPER" "SUPER"
            (hypr-translate-mod "s"))

(test-equal "hypr-translate-mod ALT" "ALT"
            (hypr-translate-mod "M"))

(test-equal "hypr-translate-mod unknown" "unknown"
            (hypr-translate-mod "unknown"))

(test-equal "hypr-translate-bind mouse-left" "mouse:272"
            (hypr-translate-bind "mouse-left"))

(test-equal "hypr-translate-bind mouse-right" "mouse:273"
            (hypr-translate-bind "mouse-right"))

(test-equal "hypr-translate-bind passthrough" "key"
            (hypr-translate-bind "key"))

(test-equal "hypr-bind basic" "SUPER, key, dispatch, cmd"
            (hypr-bind #:mod "SUPER"
                       #:bind "key"
                       #:dispatch 'dispatch
                       #:cmd "cmd"))

(test-equal "exec-bind basic" "SUPER, key, exec, cmd"
            (exec-bind #:mod "SUPER"
                       #:bind "key"
                       #:cmd "cmd"))

(test-equal "special-bind basic" "SUPER, key, dispatch"
            (special-bind #:mod "SUPER"
                          #:bind "key"
                          #:dispatch 'dispatch))

(test-end)
