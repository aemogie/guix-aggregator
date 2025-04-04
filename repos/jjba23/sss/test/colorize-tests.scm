;;; SSS - Supreme Sexp System

;; Copyright (C) 2025 - Josep Bigorra, jjba23 <jjbigorra@gmail.com>

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

(use-modules (ice-9 regex)
             (ice-9 rdelim))

;;; Macro to loop over lines of current input port,
;;; matching against a series of regular expressions.
;;; Tries to be efficient by compiling all the REs outside the loop.
(define-syntax awkish
  (lambda (stx)
    (syntax-case stx
                 (else)
                 ((_ var
                     (pat body ...) ...
                     (else else-body ...))
                  (with-syntax (((re ...)
                                 (datum->syntax #f
                                                (generate-temporaries (syntax (pat
                                                                               ...))))))
                               (syntax (let ((re (make-regexp pat))
                                             ...)
                                         (do ((var (read-line)
                                                   (read-line)))
                                             ((eof-object? var))
                                             (cond
                                               ((regexp-exec re var)
                                                body ...) ...
                                               (else else-body ...))))))))))

;;; output utilities
(define colors
  '((red . 31) (green . 32)
    (yellow . 33)
    (blue . 34)
    (magenta . 35)
    (cyan . 36)))
(define (colored col str)
  (format #t "\x1b[~Am~A\x1b[0m\n"
          (cdr (assq col colors)) str))

;;; the real work happens here
(awkish line
        ("compiling|compiled" (colored 'blue line))
        ("WARNING" (colored 'yellow line))
        ("(Entering|Leaving) test group" (colored 'cyan line))
        ("PASS" (colored 'green line))
        ("# of expected passes" (colored 'cyan line))
        ("FAIL" (colored 'red line))
        (else (write-line line)))
