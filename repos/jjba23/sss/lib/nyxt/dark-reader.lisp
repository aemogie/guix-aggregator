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

;; Code:

(in-package #:nyxt-user)

(define-configuration nx-dark-reader:dark-reader-mode
  ((nxdr:selection-color "#CD5C5C")
   (nxdr:background-color "black")
   (nxdr:text-color "white")
   (nxdr:grayscale 50)
   (nxdr:contrast 100)
   (nxdr:brightness 100)))

(define-configuration :web-buffer
  ((default-modes `(nx-dark-reader:dark-reader-mode ,@%slot-value%))))
