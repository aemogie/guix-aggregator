;;; theme.el --- Themes and look/feel for Emacs -*- lexical-binding: t -*-

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

;; Themes and look/feel for Emacs UI/UX/DX

;;; Code:

(use-package ef-themes
  :ensure (:host github :repo "protesilaos/ef-themes" :branch "main")
  :config
  (setq modus-themes-mixed-fonts t
        modus-themes-italic-constructs t)
  (modus-themes-include-derivatives-mode 1)
  (cond ((equal sss-emacs-theme 'ef-dream) (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-bio)
         (setq ef-bio-palette-overrides '((variable fg-main)
                                          (string green-faint)))
         (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-cyprus)
         (setq ef-cyprus-palette-overrides '((variable fg-main)
                                             (bg-main bg-dim)
                                             (string green-faint)))
         (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-melissa-light)
         (setq ef-melissa-light-palette-overrides '((variable fg-main)
                                                    (string green-warmer)))
         (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-tritanopia-dark) (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'ef-autumn)
         (setq ef-autumn-palette-overrides '((variable fg-main)
                                             (bg-main bg-dim)))
         (load-theme sss-emacs-theme t))))


(use-package solarized-theme
  :ensure (:host github :repo "bbatsov/solarized-emacs" :branch "master")
  :config
  (cond ((equal sss-emacs-theme 'solarized-light) (load-theme sss-emacs-theme t))))

(use-package everforest
  :ensure (:host github :repo "Theory-of-Everything/everforest-emacs" :branch "master2")
  :no-require t
  :config
  (cond ((equal sss-emacs-theme 'everforest-hard-dark)
         (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'everforest-hard-light)
         (load-theme sss-emacs-theme t))))

(use-package gruvbox-theme
  :ensure (:host github :repo "greduan/emacs-theme-gruvbox" :branch "master")
  :config
  (cond ((equal sss-emacs-theme 'gruvbox-dark-hard) (load-theme sss-emacs-theme t))
        ((equal sss-emacs-theme 'gruvbox-light-hard) (load-theme sss-emacs-theme t))))

(use-package dracula-theme
  :ensure t
  :config
  (cond ((equal sss-emacs-theme 'dracula)
         (progn
           (load-theme sss-emacs-theme t)
           ;; Tweak the font size for some headings and titles
           (setq dracula-enlarge-headings t)

           ;; Adjust font size of titles level 1 (default 1.3)
           (setq dracula-height-title-1 1.25)

           ;; Adjust font size of titles level 2 (default 1.1)
           (setq dracula-height-title-2 1.15)

           ;; Adjust font size of titles level 3 (default 1.0)
           (setq dracula-height-title-3 1.05)

           ;; Adjust font size of document titles (default 1.44)
           (setq dracula-height-doc-title 1.4)

           ;; Use less pink and bold on the mode-line and minibuffer (default nil)
           (setq dracula-alternate-mode-line-and-minibuffer nil)))
        ))

(use-package catppuccin-theme
  :ensure t
  :config
  (cond ((equal sss-emacs-theme 'catppuccin-latte)
         (setopt catppuccin-flavor 'latte)
         (load-theme 'catppuccin t))
        ((equal sss-emacs-theme 'catppuccin-mocha)
         (setopt catppuccin-flavor 'mocha)
         (load-theme 'catppuccin t)))
  )


(provide 'sss/theme)

;;; theme.el ends here
