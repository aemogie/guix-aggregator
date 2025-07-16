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

(setup-i18n)

(define (flatpak-profile-install x)
  (log-info (G_ "Installing Flatpak package: ~a") x)
  (syscall (format #f "flatpak --user install -y ~a" x)))

(define (flatpak-font-cache-clean x)
  (log-info (G_ "Cleaning font caches for package: ~a") x)
  (syscall (format #f "flatpak run --command=fc-cache ~a -f -v" x)))

(define (flatpak-remote-install x)
  (log-info (G_ "Installing Flatpak remote: ~a") x)
  (syscall (format #f "flatpak --user remote-add --if-not-exists ~a ~a"
                   (car x)
                   (cdr x))))

(for-each flatpak-remote-install
          (get-setting 'flatpak-user-remotes))

(for-each flatpak-profile-install
          (get-setting 'flatpak-pkgs))

(for-each flatpak-font-cache-clean
          (get-setting 'flatpak-pkgs))
