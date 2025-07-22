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

(define-module (veritas unit dconf-spec)
  #:use-module (veritas veritas)
  #:use-module (sss dconf)
  #:export (spec))

(define expected-dconf-writer-commands
  '("echo \"/org/gnome/desktop/interface/gtk-key-theme --> 'Emacs'\" && dconf write \"/org/gnome/desktop/interface/gtk-key-theme\" \"'Emacs'\""
    "echo \"/org/gnome/desktop/interface/cursor-size --> 24\" && dconf write \"/org/gnome/desktop/interface/cursor-size\" \"24\""
    "echo \"/org/gnome/desktop/interface/enable-animations --> true\" && dconf write \"/org/gnome/desktop/interface/enable-animations\" \"true\""))

(define dconf-test-suite
  (suite "dconf test suite"
         (test "mk-nested-dconf-writer-commands"
               (assert-equal #:sut (mk-nested-dconf-writer-commands '(("/org/gnome/desktop/interface"
                                                                       (gtk-key-theme . "'Emacs'")
                                                                       (cursor-size . 24)
                                                                       (enable-animations . true))))
                             #:expected expected-dconf-writer-commands))))

(define (spec)
  (run-suites dconf-test-suite))

