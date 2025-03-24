(setq debbugs-gnu-default-packages '("guix" "guix-patches"))
(setq debbugs-gnu-default-severities '("serious" "important" "normal" "minor" "wishlist")) 

;;; Bug references.
(require 'bug-reference)
(add-hook 'prog-mode-hook #'bug-reference-prog-mode)
(add-hook 'gnus-mode-hook #'bug-reference-mode)
(add-hook 'erc-mode-hook #'bug-reference-mode)
(add-hook 'gnus-summary-mode-hook #'bug-reference-mode)
(add-hook 'gnus-article-mode-hook #'bug-reference-mode)

;;; This extends the default expression (the top-most, first expression
;;; provided to 'or') to also match URLs such as
;;; <https://issues.guix.gnu.org/58697> or <https://bugs.gnu.org/58697>.
;;; It is also extended to detect "Fixes: #NNNNN" git trailers.
(setq bug-reference-bug-regexp
      (rx (group (or (seq word-boundary
                          (or (seq (char "Bb") "ug"
                                   (zero-or-one " ")
                                   (zero-or-one "#"))
                              (seq (char "Pp") "atch"
                                   (zero-or-one " ")
                                   "#")
                              (seq (char "Ff") "ixes"
                                   (zero-or-one ":")
                                   (zero-or-one " ") "#")
                              (seq "RFE"
                                   (zero-or-one " ") "#")
                              (seq "PR "
                                   (one-or-more (char "a-z+-")) "/"))
                          (group (one-or-more (char "0-9"))
                                 (zero-or-one
                                  (seq "#" (one-or-more
                                            (char "0-9"))))))
                     (seq (? "<") "https://bugs.gnu.org/"
                          (group-n 2 (one-or-more (char "0-9")))
                          (? ">"))
                     (seq (? "<") "https://issues.guix.gnu.org/"
                          (? "issue/")
                          (group-n 2 (one-or-more (char "0-9")))
                          (? ">"))))))
(setq bug-reference-url-format "https://issues.guix.gnu.org/%s")

(require 'debbugs)
(require 'debbugs-browse)
(add-hook 'bug-reference-mode-hook #'debbugs-browse-mode)
(add-hook 'bug-reference-prog-mode-hook #'debbugs-browse-mode)

;; The following allows Emacs Debbugs user to open the issue directly within
;; Emacs.
(setq debbugs-browse-url-regexp
      (rx line-start
          "http" (zero-or-one "s") "://"
          (or "debbugs" "issues.guix" "bugs")
          ".gnu.org" (one-or-more "/")
          (group (zero-or-one "cgi/bugreport.cgi?bug="))
          (group-n 3 (one-or-more digit))
          line-end))

;; Change the default when run as 'M-x debbugs-gnu'.
(setq debbugs-gnu-default-packages '("guix" "guix-patches"))

;; Show feature requests.
(setq debbugs-gnu-default-severities
  '("serious" "important" "normal" "minor" "wishlist"))
