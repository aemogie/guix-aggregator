;;; org.el --- Org configuration for Emacs -*- lexical-binding: t -*-

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

;; Org configuration for Emacs

;;; Code:

(use-package org
  :ensure nil
  :hook ((org-mode . sss-org-mode))
  :bind (:map org-mode-map
              ("C-c #" . nil))
  :bind (("C-c l v" . org-toggle-link-display))
  :custom
  (org-todo-keywords '((sequence "TODO" "WIP" "REVIEWING" "|" "DONE")))
  (org-log-done 'time)
  (org-hide-emphasis-markers t)
  (org-hide-leading-stars t)
  (org-pretty-entities t)
  (org-link-descriptive t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-edit-src-content-indentation 0)
  (org-table-convert-region-max-lines 9999)
  :config
  (defun sss-org-mode ()
    (variable-pitch-mode 1)
    (org-indent-mode)
    (auto-fill-mode 0)
    (org-restart-font-lock)
    (olivetti-mode)
    (font-lock-add-keywords
     nil
     '(("^-\\{5,\\}"  0 '(:inherit font-lock-comment-face))))
    (ignore-errors (sss-set-base-faces))))

(use-package org-roam-ui
  :ensure t
  :after (org-roam)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package org-present :ensure t)

(use-package org-auto-tangle
  :ensure t
  :after (org)
  :hook ((org-mode . org-auto-tangle-mode)))

(use-package org-roam
  :ensure t
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today))
  :init
  (setq org-roam-directory (file-truename (string-replace "$HOME" "~" sss-notes-roam-dir))
        org-roam-v2-ack t
        org-roam-node-display-template (concat "$\{title:*} " (propertize "$\{tags:10}" 'face 'org-tag)))
  :config
  (org-roam-db-autosync-mode)
  (org-roam-setup))

(use-package ob-http :ensure t)

(use-package ob-mermaid :ensure t)

(provide 'sss/org)

;;; org.el ends here
