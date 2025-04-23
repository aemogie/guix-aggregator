;;; libs.el --- Libs configuration for Emacs -*- lexical-binding: t -*-

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

;; Libs configuration for Emacs

;;; Code:

(use-package transient :ensure t)

(use-package f :ensure t)

(use-package page-break-lines :ensure t)

(use-package queue
  :ensure (:host github :repo "emacs-straight/queue" :branch "master")
  :demand t)

;; (use-package compat
;;   :ensure (:host github :repo "emacs-compat/compat" :branch "main"))

(provide 'sss/libs)

;;; libs.el ends here

