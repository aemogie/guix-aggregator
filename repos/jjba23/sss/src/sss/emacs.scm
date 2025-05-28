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

(define-module (sss emacs)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (ice-9 string-fun)
  #:use-module (sss palette)
  #:use-module (srfi srfi-64)
  #:export (bridge-emacs emacs-capability serialize-emacs-module emacs-modules))

(define* (bridge-emacs #:key palette
                       user-name
                       user-full-name
                       user-email
                       user-initials
                       clone-dir
                       notes-roam-dir
                       sans-font
                       mono-font)
  (define bridge-emacs-vars
    `((user-personal-name (value unquote
                                 (format #f "\"~a\"" user-name))
                          (type . string)
                          (description . "My personal name."))
      (user-personal-full-name (value unquote
                                      (format #f "\"~a\"" user-full-name))
                               (type . string)
                               (description . "My personal full name."))
      (user-personal-email (value unquote
                                  (format #f "\"~a\"" user-email))
                           (type . string)
                           (description . "My personal e-mail address."))
      (user-personal-initials (value unquote
                                     (format #f "\"~a\"" user-initials))
                              (type . string)
                              (description . "My personal initials."))
      (sss-clone-dir (value unquote
                            (format #f "\"~a\"" clone-dir))
                     (type . string)
                     (description . "Directory where SSS is cloned."))
      (sss-notes-roam-dir (value unquote
                                 (format #f "\"~a\"" notes-roam-dir))
                          (type . string)
                          (description . "Directory where my Org Roam notes are."))
      (sss-font-mono (value unquote
                            (format #f "\"~a\"" mono-font))
                     (type . string)
                     (description . "My preferred monospaced font family."))
      (sss-font-sans (value unquote
                            (format #f "\"~a\"" sans-font))
                     (type . string)
                     (description . "My preferred sans-serif font family."))
      (sss-emacs-theme (value unquote
                              (get-emacs-theme palette))
                       (type . string)
                       (description . "My preferred Emacs theme."))))

  (with-output-to-string (lambda ()
                           (for-each (lambda (v)
                                       (display (format #f
                                                        "
(defcustom ~a ~a
  \"~a\"
  :type '~a)

(setq ~a ~a)
"
                                                        (car v)
                                                        (assoc-ref (cdr v)
                                                                   'value)
                                                        (assoc-ref (cdr v)
                                                                   'description)
                                                        (assoc-ref (cdr v)
                                                                   'type)
                                                        (car v)
                                                        (assoc-ref (cdr v)
                                                                   'value))))
                                     bridge-emacs-vars))))

(define emacs-modules
  (make-parameter '(common-lisp consult
                                dashboard
                                dev
                                dired
                                eglot
                                emacs-core
                                erc
                                go
                                libs
                                macros
                                maps
                                misc
                                music
                                org
                                search
                                shell
                                sss
                                theme
                                ui)))

(define* (serialize-emacs-module #:key clone-dir mod)
  `(,(format #f ".emacs.d/modules/~a.el" mod) ,(local-file (format #f
                                                            "~a/src/sss/emacs/modules/~a.el"
                                                            (string-replace-substring
                                                             clone-dir "$HOME"
                                                             (getenv "HOME"))
                                                            mod))))

(define* (emacs-capability #:key palette
                           user-name
                           user-full-name
                           user-email
                           user-initials
                           clone-dir
                           notes-roam-dir
                           sans-font
                           mono-font)
  (append `((".emacs.d/init.el" ,(local-file "./emacs/init.el"))
            
            (".emacs.d/sss-bridge.el" ,(plain-file "sss-bridge.el"
                                                   (string-append (string-join '
                                                                   (";; ====== SSS Emacs bridge ======"
                                                                    ";;"
                                                                    ";; auto-generated file, DO NOT EDIT!"
                                                                    "") "\n")
                                                                  (bridge-emacs
                                                                   #:palette
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
                                                                   notes-roam-dir
                                                                   #:sans-font
                                                                   sans-font
                                                                   #:mono-font
                                                                   mono-font))))

            (".emacs.d/early-init.el" ,(local-file "./emacs/early-init.el"))
            (".emacs.d/templates" ,(local-file "./emacs/templates")))
          (map (lambda (m)
                 (serialize-emacs-module #:mod m
                                         #:clone-dir clone-dir))
               (emacs-modules))))

