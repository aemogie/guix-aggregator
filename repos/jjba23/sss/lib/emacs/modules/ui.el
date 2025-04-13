;;; ui.el --- SSS configuration for Emacs -*- lexical-binding: t -*-

;; Copyright (C) 2025 Josep Bigorra

;; Author: Josep Bigorra <jjbigorra@gmail.com>
;; Maintainer: Josep Bigorra <jjbigorra@gmail.com>
;; URL: https://codeberg.org/jjba23/sss

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

;; UI configuration for Emacs

;;; Code:

(use-package pulsar
  :ensure t
  :custom
  (pulsar-pulse t)
  (pulsar-delay 0.055)
  (pulsar-iterations 10)
  (pulsar-highlight-face 'pulsar-yellow)
  :config
  (cond ((equal sss-emacs-theme 'ef-dream) (setq pulsar-face 'pulsar-magenta))
        ((equal sss-emacs-theme 'everforest-hard-dark) (setq pulsar-face 'pulsar-green))
        ((equal sss-emacs-theme 'everforest-hard-light) (setq pulsar-face 'pulsar-green))
        (t (setq pulsar-face 'pulsar-green)))
  (pulsar-global-mode 1)
  (ignore-errors
    (add-hook 'consult-after-jump-hook #'pulsar-recenter-top)
    (add-hook 'consult-after-jump-hook #'pulsar-reveal-entry)))

(use-package olivetti
  :ensure t)
