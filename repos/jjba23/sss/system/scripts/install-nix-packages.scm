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
             (sss prelude))

(define (syscall cmd)
  (let* ((process (open-input-pipe cmd))
         (process-output (get-string-all process)))
    (close-pipe process)
    (display process-output) process-output))

(define (nix-profile-install x)
  (display (format #f "\n>>= installing nix package ~a\n" x))
  (syscall (format #f
                   (string-append "nix profile list | grep ~a ||"
                    " NIXPGS_ALLOW_UNFREE=1 nix -L profile install --impure nixpkgs#~a")
                   x x)))

(for-each (lambda (x)
            (nix-profile-install x))
          (get-setting 'nixpkgs))
