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

(define-module (sss prelude)
  #:declarative? #t
  #:use-module (sss defaults)
  #:use-module (sss overrides)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 regex)

  #:export (log-exprs get-setting pretty-quote))

(define-syntax-rule (log-exprs exp ...)
  (begin
    (format #t "~a: ~S\n"
            (pretty-quote (with-output-to-string (lambda ()
                                                   (write 'exp)))) exp) ...))

(define (get-setting setting)
  (let* ((default-var-name (format #f "default-~a" setting))
         (default (module-variable (resolve-module '(sss defaults))
                                   (string->symbol default-var-name)))
         (user-override-var-name (format #f "override-~a" setting))
         (user-override (module-variable (resolve-module '(sss overrides))
                                         (string->symbol
                                          user-override-var-name))))
    (catch #t
           (lambda ()
             (if (equal? #f user-override)
                 (variable-ref default)
                 (variable-ref user-override)))
           (lambda (key . args)
             (variable-ref default)))))

(define (string-drop-first-last-n s n)
  (if (> (string-length s) 2)

      (string-take (string-drop s n)
                   (- (string-length s)
                      (+ 1 n))) s))

(define (pretty-quote str)
  (regexp-substitute/global #f
                            "\\((quote [^)]*)\\)*"
                            str
                            'pre
                            (lambda (m)
                              
                              (let* ((mm (string-drop-first-last-n (match:substring
                                                                    m) 1)))
                                (string-replace-substring mm "quote " "'")))
                            'post))
