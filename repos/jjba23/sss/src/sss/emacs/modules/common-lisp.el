;;; common-lisp.el --- Common Lisp configuration for Emacs -*- lexical-binding: t -*-

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

;;; Commentary:

;; Common Lisp configuration for Emacs

;;; Code:

;; Configure the Sly REPL for Common Lisp development
(use-package sly
  :ensure (:host github :repo "joaotavora/sly" :branch "master")
  :demand t
  :init
  (setq inferior-lisp-program "/run/current-system/profile/bin/sbcl"))


(provide 'sss/common-lisp)

;;; common-lisp.el ends here
