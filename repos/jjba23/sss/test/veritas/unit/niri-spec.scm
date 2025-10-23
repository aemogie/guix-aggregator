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

(define-module (veritas unit niri-spec)
  #:use-module (veritas veritas)
  #:use-module (sss niri)
  #:export (spec))

(define niri-suite
  (suite "Niri test suite"
         (test "full-run of generating a simple niri config"
               (assert-no-error (lambda ()
                                  (define niri-cfg
                                    (niri-config #:palette 'dracula
                                                 #:sans-font "IBM Plex Sans"
                                                 #:mono-font "IBM Plex Mono"
                                                 #:keyboard-layout "us"
                                                 #:caps-to-ctrl? #t))

                                  (display (string-join (serialize-kdl
                                                         niri-cfg) "\n")))))))

(define (spec)
  (veritas-run niri-suite))

