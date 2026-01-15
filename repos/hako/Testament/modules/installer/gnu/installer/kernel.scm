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

(define-module (gnu installer kernel)
  #:use-module (ice-9 match)
  #:use-module (gnu system hurd)
  #:use-module (guix read-print)
  #:export (kernel->configuration))

(define (kernel->configuration kernel dry-run?)
  (match kernel
    ("Linux"
     `((kernel linux)
       (firmware (cons* linux-firmware %base-firmware))
       (initrd microcode-initrd)))
    ("Linux LTS"
     `((kernel linux-lts)
       (firmware (cons* linux-firmware %base-firmware))
       (initrd microcode-initrd)))
    (_
     '())))
