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
  #:use-module (sss palette)
  #:use-module (sss overrides)
  #:use-module (ice-9 string-fun)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 time)
  #:use-module (ice-9 format)
  #:use-module (ice-9 iconv)
  #:use-module (ice-9 threads)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (gnu services configuration)
  #:export (log-exprs get-setting
                      log-active-sss-settings
                      pretty-quote
                      string-drop-first-last-n
                      syscall
                      mk-lines
                      mk-kv-conf-lines
                      serialize-rec-conf-item
                      mk-rec-kv-conf-lines
                      spaced-equal-conf-pair
                      equal-conf-pair
                      equal-conf-quote-value-pair
                      nix-profile-install
                      mk-css-conf-lines))

(define-syntax-rule (log-exprs exp ...)
  "Log a variadic number of expressions, and the result of their evaluation."
  (begin
    (format #t
            "~a~a:~a ~a~S~a\n"
            (assoc-ref ansi-color-escapes
                       'green)
            (pretty-quote (with-output-to-string (lambda ()
                                                   (write 'exp))))
            (assoc-ref ansi-color-escapes
                       'reset)
            (assoc-ref ansi-color-escapes
                       'default)
            exp
            (assoc-ref ansi-color-escapes
                       'reset)) ...))

(define-syntax-rule (get-setting setting)
  "Get a setting for SSS, either from override or from default values."
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

(define-syntax-rule (log-active-sss-settings)
  (catch #t
         (lambda ()
           (log-exprs (get-setting 'lang)
                      (get-setting 'timezone)
                      (get-setting 'keyboard-layout)
                      (get-setting 'caps-to-ctrl?)
                      (get-setting 'hostname)
                      (get-setting 'clone-dir)
                      (get-setting 'palette)
                      (get-setting 'mono-font)
                      (get-setting 'sans-font)
                      (get-setting 'serif-font)
                      (get-setting 'hyprland-monitors)
                      (get-setting 'hyprland-extra-startups)
                      (get-setting 'labwc-extra-startups)
                      (get-setting 'flatpak-user-remotes)
                      (length (get-setting 'flatpak-pkgs))
                      (length (get-setting 'extra-packages))
                      (length (get-setting 'nixpkgs))))
         (lambda (key . args)
           (display (format #f "error logging active SSS settings: ~a: ~a" key
                            args)))))

(define-syntax-rule (string-drop-first-last-n s n)
  (let* ((len (string-length s))
         (start-idx n)
         (end-idx (- len n)))
    (if (>= start-idx end-idx) s
        (substring s start-idx end-idx))))

(define-syntax-rule (pretty-quote str)
  (regexp-substitute/global #f
                            "\\((quote [^)]*)\\)*"
                            str
                            'pre
                            (lambda (m)
                              
                              (let* ((mm (string-drop-first-last-n (match:substring
                                                                    m) 1)))
                                (string-replace-substring mm "quote " "'")))
                            'post))

(define (syscall cmd)
  "Executes a system command and returns its output as a string.
 Be cautious with input: Passing untrusted or unsanitized strings can lead to
security vulnerabilities (e.g. shell injection attacks)."
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output) process-output))

(define (mk-lines items)
  (with-output-to-string (lambda ()
                           (for-each (lambda (x)
                                       (display (format #f "~a\n" x))) items))))

(define* (mk-css-conf-lines pairs)
  "Create a CSS configuration from PAIRS, a selector to values alist."
  (with-output-to-string (lambda ()
                           (for-each (lambda (x)
                                       (display (format #f "~a {\n"
                                                        (car x)))
                                       (display (mk-kv-conf-lines (cdr x)
                                                                  #:template
                                                                  "  ~a: ~a;\n"))
                                       (display "}\n\n")) pairs))))

(define* (mk-kv-conf-lines pairs
                           #:key (template "~a=~a\n"))
  (with-output-to-string (lambda ()
                           (for-each (lambda (x)
                                       (display (format #f template
                                                        (car x)
                                                        (cdr x)))) pairs))))

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
                                       (serialize-rec-conf-item template item))
                                     pairs))))

(define spaced-equal-conf-pair
  "~a = ~a\n")

(define equal-conf-pair
  "~a=~a\n")

(define equal-conf-quote-value-pair
  "~a=\"~a\"\n")

(define (nix-profile-install x)
  (syscall (format #f "nix -L profile install --impure nixpkgs#~a" x)))

