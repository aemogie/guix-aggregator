;; -*- lexical-binding: t; -*-

(use-package org
  :custom
  (org-hide-emphasis-markers t)
  :preface
  (defun disable (mode)
    (lambda () (funcall mode -1)))
  (defun tex-completions ()
    (add-to-list 'completion-at-point-functions #'cape-tex))
  :hook ((org-src-mode . display-line-numbers-mode)
         (org-mode . (org-appear-mode
                      org-fragtog-mode
                      org-modern-mode
                      ;(disable 'display-fill-column-indicator-mode)
                      tex-completions))))

(provide 'anemofilia/org)
