(defun guile-sort-modules ()
  (interactive)
  (let ((module-start-rx (rx bol (+ space) "#:use-module"))
        (module-name-rx (rx (+ "(") (group (+ (not ")"))) ")")))
    (save-excursion
      (save-restriction
        (narrow-to-defun)
        (beginning-of-defun)
        (re-search-forward module-start-rx nil t)
        (goto-char (match-beginning 0))
        (sort-subr nil
                   (lambda ()
                     (if (re-search-forward module-start-rx nil t)
                         (goto-char (match-beginning 0))
                       (goto-char (point-max))))
                   (lambda () (forward-sexp 2))
                   (lambda ()
                     (save-excursion
                       (re-search-forward module-name-rx nil t)
                       (match-string 1))))
        (widen)))))
