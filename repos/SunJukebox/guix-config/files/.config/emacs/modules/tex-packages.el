;;; tex-packages.el --- Packages for LaTeX configuration  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(when (executable-find "latex")
  (add-to-list 'package-selected-packages 'auctex)
  (add-to-list 'package-selected-packages 'cdlatex)
  (add-to-list 'package-selected-packages 'aas))
  
(provide 'tex-packages)
;;; anon-latex-packages.el ends here
