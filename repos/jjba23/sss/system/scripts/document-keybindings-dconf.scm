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

(use-modules (ice-9 popen)
             (ice-9 textual-ports)
             (ice-9 readline)
             (ice-9 string-fun)
             (sss prelude)
             (sss keybindings-docs)
             (json))

(setup-i18n)

;; document power-user keybindings
(log-info (G_ "Documenting power-user keybindings in JSON format"))

(with-output-to-file "power-user-tmp.json"
  (lambda ()
    (scm->json power-user-sss-keybindings-docs)))

(log-info (G_ "Writing power-user keybindings to dconf"))

(define power-user-cmd
  (format #f
   "dconf write '/sss/power-user-keybindings-docs' \"'~a'\" && rm power-user-tmp.json"
   (syscall "cat power-user-tmp.json | xxd -plain | tr -d '\\n'"
            #:silent? #t)))

(syscall power-user-cmd
         #:silent? #t)

;; document universal session keybindings
(log-info (G_ "Documenting universal-session keybindings in JSON format"))

(with-output-to-file "universal-session-tmp.json"
  (lambda ()
    (scm->json universal-session-sss-keybindings-docs)))

(log-info (G_ "Writing universal-session keybindings to dconf"))

(define universal-session-cmd
  (format #f
   "dconf write '/sss/universal-session-keybindings-docs' \"'~a'\" && rm universal-session-tmp.json"
   (syscall "cat universal-session-tmp.json | xxd -plain | tr -d '\\n'"
            #:silent? #t)))

(syscall universal-session-cmd
         #:silent? #t)
