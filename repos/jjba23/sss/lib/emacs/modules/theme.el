;;; theme.el --- Themes and look/feel for Emacs -*- lexical-binding: t -*-

;; Copyright (C) 2025 Josep Bigorra

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

;; Themes and look/feel for Emacs UI/UX/DX

;;; Code:

(use-package ef-themes
  :ensure (:host github :repo "protesilaos/ef-themes" :branch "main")
  :config
  (setq ef-bio-palette-overrides '((variable fg-main)
                                   (string green-faint)))
  (setq ef-autumn-palette-overrides '((variable fg-main)
                                      (bg-main bg-dim)))
  (setq ef-cyprus-palette-overrides '((variable fg-main)
                                      (bg-main bg-dim)
                                      (string green-faint)))
  (cond ((equal sss-emacs-theme 'ef-dream) (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-bio) (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-cyprus) (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-tritanopia-dark) (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-autumn) (load-theme sss-emacs-theme t))))


(use-package solarized-theme
  :ensure (:host github :repo "bbatsov/solarized-emacs" :branch "master")
  :config
  (cond ((equal sss-emacs-theme 'solarized-light) (load-theme sss-emacs-theme t))))

(use-package everforest
  :ensure (:host github :repo "Theory-of-Everything/everforest-emacs" :branch "master")
  :no-require t
  :config
  (cond ((equal sss-emacs-theme 'everforest-hard-dark)
         (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'everforest-hard-light)
         (load-theme sss-emacs-theme t))))


(provide 'sss/theme)

;;; theme.el ends here
