;; -*- lexical-binding: t; -*-

(use-package org
  :custom
  (org-hide-emphasis-markers t)
  (org-agenda-files '("~/areas/masters/current-period/cronogram.org"))
  (org-agenda-span 'week)
  (org-agenda-start-day "monday")
  (org-agenda-start-on-weekday 1)
  (org-agenda-include-diary t)
  (org-agenda-time-grid '((daily today require-timed)
                          (800 1000 1200 1400 1600 1800)
                          "......" "----------------"))
  :preface
  (defun disable (mode)
    (lambda () (funcall mode -1)))
  (defun tex-completions ()
    (add-to-list 'completion-at-point-functions #'cape-tex))
  :hook ((org-src-mode . display-line-numbers-mode)
         (org-mode . org-appear-mode)
         (org-mode . org-fragtog-mode)
         (org-mode . org-modern-mode)
         ;(org-mode . (disable 'display-fill-column-indicator-mode))
         (org-mode . tex-completions)))

(provide 'anemofilia/org)
