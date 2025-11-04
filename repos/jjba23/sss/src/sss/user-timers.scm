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

(define-module (sss user-timers)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss prelude)
  #:use-module (gnu home services shepherd)
  #:export (user-timer-script user-timer))

(define* (user-timer #:key name user gexp)
  (let ((timer-name (string->symbol (format #f "user-timer-~a" name))))
    (simple-service timer-name home-shepherd-service-type
                    (list (shepherd-timer (list timer-name) gexp
                                          `("bash" ,(format #f
                                                     "/home/~a/.local/bin/~a.bash"
                                                     user timer-name))

                                          )))))

(define* (user-timer-script #:key name cmd)
  (let ((timer-name (format #f "user-timer-~a" name)))
    `((,(format #f ".local/bin/~a.bash" timer-name) ,(plain-file timer-name
                                                                 (string-join (list
                                                                               "#!/usr/bin/env bash"
                                                                               cmd)
                                                                  "\n"))))))

