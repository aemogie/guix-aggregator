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

(define-module (sss emacs)
  #:use-module (gnu)
  #:use-module (srfi srfi-64))

(begin
  (define* (sss-bridge-emacs #:key palette
                             user-name
                             user-full-name
                             user-email
                             user-initials
                             clone-dir
                             notes-roam-dir)
    (define sss-bridge-emacs-vars
      `((user-personal-name unquote
                            (format #f "\"~a\"" user-name))
        (user-personal-full-name unquote
                                 (format #f "\"~a\"" user-full-name))
        (user-personal-email unquote
                             (format #f "\"~a\"" user-email))
        (user-personal-initials unquote
                                (format #f "\"~a\"" user-initials))
        (sss-clone-dir unquote
                       (format #f "\"~a\"" clone-dir))
        (sss-notes-roam-dir unquote
                            (format #f "\"~a\"" notes-roam-dir))
        (sss-emacs-theme unquote
                         (cond
                           ((equal? palette
                                    'sss-palette-ef-dream)
                            "'ef-dream")
                           ((equal? palette
                                    'sss-palette-ef-cyprus)
                            "'ef-cyprus")
                           ((equal? palette
                                    'sss-palette-ef-autumn)
                            "'ef-autumn")
                           ((equal? palette
                                    'sss-palette-heavy-metal)
                            "'ef-tritanopia-dark")
                           ((equal? palette
                                    'sss-palette-everforest-dark)
                            "'everforest-hard-dark")
                           ((equal? palette
                                    'sss-palette-everforest-light)
                            "'everforest-hard-light")
                           ((equal? palette
                                    'sss-palette-solarized-light)
                            "'solarized-light")
                           (else "'ef-bio")))))

    (with-output-to-string (lambda ()
                             (display "(setq-default")
                             (for-each (lambda (v)
                                         (display (format #f "\n    ~a ~a"
                                                          (car v)
                                                          (cdr v))))
                                       sss-bridge-emacs-vars)
                             (display ")\n"))))
  (export sss-bridge-emacs))

(begin
  (define* (sss-emacs-svc #:key palette
                          user-name
                          user-full-name
                          user-email
                          user-initials
                          clone-dir
                          notes-roam-dir)
    `((".emacs.d/init.el" ,(local-file "./emacs/init.el"))
      
      (".emacs.d/sss-bridge.el" ,(plain-file "sss-bridge.el"
                                             (sss-bridge-emacs #:palette
                                                               palette
                                                               #:user-name
                                                               user-name
                                                               #:user-full-name
                                                               user-full-name
                                                               #:user-email
                                                               user-email
                                                               #:user-initials
                                                               user-initials
                                                               #:clone-dir
                                                               clone-dir
                                                               #:notes-roam-dir
                                                               notes-roam-dir)))

      (".emacs.d/early-init.el" ,(local-file "./emacs/early-init.el"))
      (".emacs.d/modules/common-lisp.el" ,(local-file
                                           "./emacs/modules/common-lisp.el"))
      (".emacs.d/modules/go.el" ,(local-file "./emacs/modules/go.el"))
      (".emacs.d/modules/org.el" ,(local-file "./emacs/modules/org.el"))
      (".emacs.d/modules/eglot.el" ,(local-file "./emacs/modules/eglot.el"))
      (".emacs.d/modules/dashboard.el" ,(local-file
                                         "./emacs/modules/dashboard.el"))
      (".emacs.d/modules/theme.el" ,(local-file "./emacs/modules/theme.el"))
      (".emacs.d/modules/sss.el" ,(local-file "./emacs/modules/sss.el"))
      (".emacs.d/modules/erc.el" ,(local-file "./emacs/modules/erc.el"))
      (".emacs.d/modules/consult.el" ,(local-file "./emacs/modules/consult.el"))
      (".emacs.d/modules/emacs-core.el" ,(local-file
                                          "./emacs/modules/emacs-core.el"))
      (".emacs.d/modules/dev.el" ,(local-file "./emacs/modules/dev.el"))
      (".emacs.d/templates" ,(local-file "./emacs/templates"))))
  (export sss-emacs-svc))

;; ====== module tests ======

(test-begin "Emacs bridge tests")
(test-assert "bridge is correctly computed"
             (equal? (string-append "(setq-default
    user-personal-name \"John\"
"
                      "    user-personal-full-name \"John Doe\"\n"
                      "    user-personal-email \"john@doe.com\"\n"
                      "    user-personal-initials \"JD\"\n"
                      "    sss-clone-dir \"/home/john\"\n"
                      "    sss-notes-roam-dir \"/home/john/notes/roam\"
"
                      "    sss-emacs-theme 'ef-bio)\n")
                     (sss-bridge-emacs #:palette 'sss-palette-ef-bio
                                       #:user-name "John"
                                       #:user-full-name "John Doe"
                                       #:user-email "john@doe.com"
                                       #:user-initials "JD"
                                       #:clone-dir "/home/john"
                                       #:notes-roam-dir
                                       "/home/john/notes/roam")))

(test-end)
