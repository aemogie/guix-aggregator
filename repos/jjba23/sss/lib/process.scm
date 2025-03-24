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

(define-module (sss process)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (ice-9 time)
  #:use-module (ice-9 format)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 threads)
  #:use-module (ice-9 rdelim)
  #:use-module ((ice-9 binary-ports)
                #:prefix i9:)
  #:use-module ((ice-9 textual-ports)
                #:prefix i9:)
  #:use-module (gnu services configuration))

;;; Code:

;; Executes a system command and returns its output as a string.
;;
;; Be cautious with input: Passing untrusted or unsanitized strings can lead to security vulnerabilities (e.g. shell injection attacks).
(define-public (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output) process-output))

(define-public (mk-lines items)
  (with-output-to-string (lambda ()
                           (for-each (lambda (x)
                                       (display (format #f "~a\n" x))) items))))

;; Create a CSS configuration from PAIRS, a selector to values alist.
(begin
  (define* (mk-css-conf-lines pairs)
    (with-output-to-string (lambda ()
                             (for-each (lambda (x)
                                         (display (format #f "~a {\n"
                                                          (car x)))
                                         (display (mk-kv-conf-lines (cdr x)
                                                   #:template "  ~a: ~a;\n"))
                                         (display "}\n\n")) pairs))))
  (export mk-css-conf-lines))

(begin
  (define* (mk-kv-conf-lines pairs
                             #:key (template "~a=~a\n"))
    (with-output-to-string (lambda ()
                             (for-each (lambda (x)
                                         (display (format #f template
                                                          (car x)
                                                          (cdr x)))) pairs))))
  (export mk-kv-conf-lines))

(begin
  (define (serialize-rec-conf-item template item)
    (cond
      ((alist? (cdr item))
       (cond
         ((string? (car item))
          (display (string-append "\n["
                                  (car item) "]\n")))
         (else (display (string-append "\n["
                                       (symbol->string (car item)) "]\n"))))
       (display (mk-rec-kv-conf-lines (cdr item)
                                      #:template template)))
      (else (display (format #f template
                             (car item)
                             (cdr item))))))

  (define* (mk-rec-kv-conf-lines pairs
                                 #:key (template "~a=~a\n"))
    (with-output-to-string (lambda ()
                             (for-each (lambda (item)
                                         (serialize-rec-conf-item template
                                                                  item)) pairs))))
  (export mk-rec-kv-conf-lines))

(define-public spaced-equal-conf-pair
  "~a = ~a\n")

(define-public equal-conf-pair
  "~a=~a\n")

(define-public (nix-profile-install x)
  (syscall (format #f "nix -L profile install --impure nixpkgs#~a" x)))

(define-public (read-text path)
  (let* ((file (open-file path "r"))
         (text (i9:get-string-all file)))
    (close-port file) text))

(define-public (read-line path)
  (let* ((file (open-file path "r"))
         (line (i-read-line file)))
    (close-port file) line))

(define-public (read-lines path)
  (let* ((file (open-file path "r"))
         (lines (i-read-lines file)))
    (close-port file) lines))

(define (i-read-line port)
  (i9:get-line port))

(define (i-read-lines port)
  (letrec ((loop (lambda (l ls)
                   (if (eof-object? l) ls
                       (loop (i9:get-line port)
                             (cons l ls))))))
    (reverse (loop (i9:get-line port)
                   '()))))
