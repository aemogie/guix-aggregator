;;; consult.el --- Consult configuration for Emacs -*- lexical-binding: t -*-

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

;; Consult configuration for Emacs

;;; Code:

(use-package consult 
  :ensure t  
  :bind (
         ("C-c m" . consult-mode-command) 
         ("C-c k" . consult-kmacro) 
         ("C-x M-:" . consult-complex-command) 
         ("C-x b" . consult-buffer) 
         ("C-x 4 b" . consult-buffer-other-window) 
         ("C-x 5 b" . consult-buffer-other-frame) 
         ("C-x r b" . consult-bookmark) 
         ("C-x p b" . consult-project-buffer) 
         ("M-#" . consult-register-load) 
         ("M-'" . consult-register-store) 
         ("C-M-#" . consult-register) 
         ("M-y" . consult-yank-pop) 
         ("M-g e" . consult-compile-error) 
         ("M-g f" . consult-flymake) 
         ("M-g g" . consult-goto-line) 
         ("M-g M-g" . consult-goto-line) 
         ("M-g o" . consult-outline) 
         ("M-g m" . consult-mark) 
         ("M-g k" . consult-global-mark) 
         ("M-g i" . consult-imenu) 
         ("M-g I" . consult-imenu-multi) 
         ("M-s d" . consult-find) 
         ("M-s D" . consult-locate) 
         ("M-s g" . consult-grep) 
         ("M-s G" . consult-git-grep) 
         ("M-s r" . consult-ripgrep) 
         ("M-s l" . consult-line) 
         ("M-s L" . consult-line-multi) 
         ("M-s k" . consult-keep-lines) 
         ("M-s u" . consult-focus-lines) 
         ("M-s e" . consult-isearch-history)) 
  :hook ((completion-list-mode . consult-preview-at-point-mode)) 
  :init (setq register-preview-delay 0.5 register-preview-function #'consult-register-format xref-show-xrefs-function #'consult-xref xref-show-definitions-function #'consult-xref)
  (advice-add #'register-preview 
              :override #'consult-register-window) 
  :config (consult-customize consult-theme 
                             :preview-key '(:debounce 0.2 any) 
                             consult-ripgrep consult-git-grep consult-grep consult-bookmark consult-recent-file consult-xref consult--source-bookmark consult--source-file-register consult--source-recent-file consult--source-project-recent-file 
                             :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<") 
  (global-set-key [f6] 'consult-recent-file)
  )

(provide 'sss/consult)

;;; consult.el ends here
