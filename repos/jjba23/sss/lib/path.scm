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

(use-modules (ice-9 ftw))

(define *sss-makefile*
  "Makefile")

(define %current-toplevel
  (make-parameter #f))

(define* (find-MAKEFILE-path proc
                             #:optional (check-only? #f))
  (define (-> p)
    (let ((ff (string-append p "/" *sss-makefile*)))
      (and (file-exists? ff) p)))
  (define (last-path pwd)
    (and=> (string-match "(.*)/.*$" pwd)
           (lambda (m)
             (match:substring m 1))))

  (let lp
    ((pwd (getcwd)))
    (cond
      ((not (string? pwd))
       (error find-MAKEFILE-path "BUG: please report it!" pwd))
      ((string-null? pwd)
       (if check-only? #f
           (error find-MAKEFILE-path
            "No MAKEFILE! Are you in a legal SSS dir? Or maybe you need to create a new app?")))
      ((-> pwd)
       => proc)
      (else (lp (last-path pwd))))))

(define (current-toplevel)
  (or (%current-toplevel)
      (find-MAKEFILE-path identity #t)))

(define* (scan-components p
                          #:optional (sym? #t))
  (define-syntax-rule (-> x)
    (if sym?
        (string->symbol x) x))
  (let* ((toplevel (current-toplevel))
         (cpath (format #f "~a/~a/" toplevel p)))
    (cond
      ((file-exists? cpath)
       (display (format #f "starting to load modules in ~a\n" cpath))
       (map (lambda (f)
              (format #f "~a/~a/~a" toplevel p f))
            (scandir cpath
                     (lambda (f)
                       (not (or (string=? f ".")
                                (string=? f "..")
                                (string=? f ".gitkeep")
                                (< (string-length f) 4)
                                (string<> (string-take-right f 4) ".scm")
                                (string=? f "home.scm")))))))
      (else '()))))

(define (load-lib-modules)
  (let* ((lib-components (scan-components "lib"))
         (hyprland-components (scan-components "lib/hyprland"))
         (modules (append lib-components hyprland-components)))
    (for-each (lambda (s)
                (display (format #f ">>= loading ~a\n" s))
                (load s)) modules)))

