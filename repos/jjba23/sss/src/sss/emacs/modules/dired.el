;;; dired.el --- Dired configuration for Emacs -*- lexical-binding: t -*-

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

;; Dired configuration for Emacs

;;; Code:

(use-package dired-hacks-utils :ensure t)

(use-package dired-subtree
  :ensure t
  :config
  (set-face-attribute 'dired-subtree-depth-1-face nil
		                  :background 'unspecified)
  (set-face-attribute 'dired-subtree-depth-2-face nil
		                  :background 'unspecified)
  (set-face-attribute 'dired-subtree-depth-3-face nil
		                  :background 'unspecified)
  (set-face-attribute 'dired-subtree-depth-4-face nil
		                  :background 'unspecified)
  (set-face-attribute 'dired-subtree-depth-5-face nil
		                  :background 'unspecified)
  (set-face-attribute 'dired-subtree-depth-6-face nil
		                  :background 'unspecified)
  :bind (:map dired-mode-map (("<mouse-1>" . dired-subtree-toggle)
                              ("<TAB>" . dired-subtree-toggle)
                              ("C-<tab>" . dired-subtree-toggle)
                              ("C-<TAB>" . dired-subtree-toggle))))

(use-package dired-open-with :ensure t)

(use-package nerd-icons-dired
  :ensure t
  :hook ((dired-mode . nerd-icons-dired-mode)))

(provide 'sss/dired)

;;; dired.el ends here
