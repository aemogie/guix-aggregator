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

(define-module (sss hyprland hyprlang-test)
  #:use-module ((srfi srfi-64)
                #:hide (define-test))
  #:use-module (sss test-utils)
  #:use-module (sss hyprland hyprlang))

(define-test test-hyprlang
             (test-group "hyprlang"

                         (test-equal "serialize-hypr-setting basic"
                                     "key = value"
                                     (serialize-hypr-setting "key" "value"))

                         (test-equal "serialize-hypr-setting with indent"
                                     "  key = value"
                                     (serialize-hypr-setting "key" "value"
                                                             #:indent "  "))

                         (test-equal "serialize-hypr-setting nested"
                                     "    key = value"
                                     (serialize-hypr-setting "key"
                                                             "value"
                                                             #:indent "  "
                                                             #:nested #t))

                         (test-equal "serialize-hypr-section basic"
                                     "section {\n  key = value\n}"
                                     (serialize-hypr-section #:section
                                                             "section"
                                                             #:settings '(("key" . "value"))))

                         (test-equal "serialize-hypr-section nested"
                                     "section {
  subsection {
    key = value
  }
}"
                                     (serialize-hypr-section #:section
                                                             "section"
                                                             #:settings '(("subsection"
                                                                           ("key" . "value")))))

                         (test-equal "hypr-translate-mod SUPER" "SUPER"
                                     (hypr-translate-mod "s"))

                         (test-equal "hypr-translate-mod ALT" "ALT"
                                     (hypr-translate-mod "M"))

                         (test-equal "hypr-translate-mod unknown" "unknown"
                                     (hypr-translate-mod "unknown"))

                         (test-equal "hypr-translate-bind mouse-left"
                                     "mouse:272"
                                     (hypr-translate-bind "mouse-left"))

                         (test-equal "hypr-translate-bind mouse-right"
                                     "mouse:273"
                                     (hypr-translate-bind "mouse-right"))

                         (test-equal "hypr-translate-bind passthrough" "key"
                                     (hypr-translate-bind "key"))

                         (test-equal "hypr-bind basic"
                                     "SUPER, key, dispatch, cmd"
                                     (hypr-bind #:mod "SUPER"
                                                #:bind "key"
                                                #:dispatch 'dispatch
                                                #:cmd "cmd"))

                         (test-equal "exec-bind basic" "SUPER, key, exec, cmd"
                                     (exec-bind #:mod "SUPER"
                                                #:bind "key"
                                                #:cmd "cmd"))

                         (test-equal "special-bind basic"
                                     "SUPER, key, dispatch"
                                     (special-bind #:mod "SUPER"
                                                   #:bind "key"
                                                   #:dispatch 'dispatch))

                         ))
