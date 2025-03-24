;;; torrents.el --- For Torrents in Emacs -*- lexical-binding: t -*-

;;; Code:

;; torrents-csv:
(use-package torrents-csv
  :defer t
  :straight '(torrents-csv
      	      :host codeberg
      	      :repo "divyaranjan/torrents-csv.el"))

;; mentor
(use-package xml-rpc
  :straight t
  :defer t)

(use-package mentor
  :straight t
  :defer t)

(define-key global-map (kbd "C-x M-t") 'search-torrents)

(provide 'torrents.el)
;;; torrents.el ends here
