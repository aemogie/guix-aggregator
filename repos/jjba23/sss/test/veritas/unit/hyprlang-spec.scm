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
               (assert-equal #:expected "    key = value"
                             #:sut (serialize-hypr-setting "key"
                                                           "value"
                                                           #:indent "  "
                                                           #:nested #t))
               (assert-equal #:expected "key = value"
                             #:sut (serialize-hypr-setting "key" "value"))
               (assert-equal #:expected "  key = value"
                             #:sut (serialize-hypr-setting "key" "value"
                                                           #:indent "  "))

               )
         (test "serialize-hypr-section"
               (assert-equal #:expected "section {\n  key = value\n}"
                             #:sut (serialize-hypr-section #:section "section"
                                                           #:settings '(("key" . "value"))))
               (assert-equal #:expected "section {
  subsection {
    key = value
  }
}"
                             #:sut (serialize-hypr-section #:section "section"
                                                           #:settings '(("subsection"
                                                                         ("key" . "value"))))))
         (test "hypr-translate-mod"
               (assert-equal #:expected "SUPER"
                             #:sut (hypr-translate-mod "s"))

               (assert-equal #:expected "ALT"
                             #:sut (hypr-translate-mod "M"))

               (assert-equal #:expected "unknown"
                             #:sut (hypr-translate-mod "unknown")))
         (test "hypr-translate-bind"

               (assert-equal #:expected "mouse:272"
                             #:sut (hypr-translate-bind "mouse-left"))

               (assert-equal #:expected "mouse:273"
                             #:sut (hypr-translate-bind "mouse-right"))

               (assert-equal #:expected "key"
                             #:sut (hypr-translate-bind "key")))
         (test "hypr-bind"
               (assert-equal #:expected "SUPER, key, dispatch, cmd"
                             #:sut (hypr-bind #:mod "SUPER"
                                              #:bind "key"
                                              #:dispatch 'dispatch
                                              #:cmd "cmd")))
         (test "exec-bind"
               (assert-equal #:expected "SUPER, key, exec, cmd"
                             #:sut (exec-bind #:mod "SUPER"
                                              #:bind "key"
                                              #:cmd "cmd")))
         (test "special-bind"
               (assert-equal #:expected "SUPER, key, dispatch"
                             #:sut (special-bind #:mod "SUPER"
                                                 #:bind "key"
                                                 #:dispatch 'dispatch)))))

(define (spec)
  (run-suites hyprlang-suite))

