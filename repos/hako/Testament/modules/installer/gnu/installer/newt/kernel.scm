;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2024, 2026 Janneke Nieuwenhuizen <janneke@gnu.org>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu installer newt kernel)
  #:use-module (gnu installer newt page)
  #:use-module (guix i18n)
  #:use-module (guix utils)
  #:export (run-kernel-page))

(define (run-kernel-page)
  (let ((kernels
         '("Linux"
           "Linux LTS")))
    (run-listbox-selection-page
     #:title (G_ "Kernel")
     #:info-text
     (G_ "Please select a kernel.  When in doubt, choose \"Linux\".")
     #:listbox-items kernels
     #:listbox-item->text identity
     #:listbox-default-item "Linux"
     #:button-text (G_ "Back")
     #:button-callback-procedure
     (lambda _
       (abort-to-prompt 'installer-step 'abort)))))
