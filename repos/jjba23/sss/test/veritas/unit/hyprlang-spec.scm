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

(define-module (veritas unit hyprlang-spec)
  #:use-module (veritas veritas)
  #:use-module (sss hyprland hyprlang)
  #:export (spec))

(define hyprlang-suite
  (suite "Hyprlang test suite"
         (test "serialize-hypr-setting"
               (assert-equal #:expect "    key = value"
                             #:got (serialize-hypr-setting "key"
                                                           "value"
                                                           #:indent "  "
                                                           #:nested #t))
               (assert-equal #:expect "key = value"
                             #:got (serialize-hypr-setting "key" "value"))
               (assert-equal #:expect "  key = value"
                             #:got (serialize-hypr-setting "key" "value"
                                                           #:indent "  "))

               )
         (test "serialize-hypr-section"
               (assert-equal #:expect "section {\n  key = value\n}"
                             #:got (serialize-hypr-section #:section "section"
                                                           #:settings '(("key" . "value"))))
               (assert-equal #:expect "section {
  subsection {
    key = value
  }
}"
                             #:got (serialize-hypr-section #:section "section"
                                                           #:settings '(("subsection"
                                                                         ("key" . "value"))))))
         (test "hypr-translate-mod"
               (assert-equal #:expect "SUPER"
                             #:got (hypr-translate-mod "s"))

               (assert-equal #:expect "ALT"
                             #:got (hypr-translate-mod "M"))

               (assert-equal #:expect "unknown"
                             #:got (hypr-translate-mod "unknown")))
         (test "hypr-translate-bind"

               (assert-equal #:expect "mouse:272"
                             #:got (hypr-translate-bind "mouse-left"))

               (assert-equal #:expect "mouse:273"
                             #:got (hypr-translate-bind "mouse-right"))

               (assert-equal #:expect "key"
                             #:got (hypr-translate-bind "key")))
         (test "hypr-bind"
               (assert-equal #:expect "SUPER, key, dispatch, cmd"
                             #:got (hypr-bind #:mod "SUPER"
                                              #:bind "key"
                                              #:dispatch 'dispatch
                                              #:cmd "cmd")))
         (test "exec-bind"
               (assert-equal #:expect "SUPER, key, exec, cmd"
                             #:got (exec-bind #:mod "SUPER"
                                              #:bind "key"
                                              #:cmd "cmd")))
         (test "special-bind"
               (assert-equal #:expect "SUPER, key, dispatch"
                             #:got (special-bind #:mod "SUPER"
                                                 #:bind "key"
                                                 #:dispatch 'dispatch)))))

(define (spec)
  (veritas-run hyprlang-suite))

