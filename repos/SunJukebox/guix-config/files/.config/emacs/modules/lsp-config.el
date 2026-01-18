;;; lsp-config.el --- Settings for lsp-mode          -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author:  <kyle@thinkpad490>

;;; Commentary:

;;

;;; Code:

;; Require markdown config because ls can return docs in formatted
;; markdown
(require 'markdown-config)

(defun onghaik/close-eldoc-doc-buffer ()
  "Quit the Eldoc buffer window using `quit-window'.
This buries the buffer to the bottom of the buffer list and deletes the window."
  (interactive)
  (quit-window 'nil (get-buffer-window (eldoc-doc-buffer))))

(defun onghaik/eldoc-doc-buffer ()
  "Run Eldoc at symbol at point, switching to the Eldoc buffer in another window."
  (interactive)
  (switch-to-buffer-other-window (eldoc-doc-buffer)))

(use-package eldoc
  :ensure nil ;; built-in
  :defer t
  :custom
  ;; Do not use multiline for documentation in the echo area (minibuffer)
  ;; FIXME: Do I actually want this? Perhaps just signatures in the minibuffer?
  (eldoc-echo-area-use-multiline-p 'nil)
  ;; Prefer to use the doc-buffer if it is already showing, rather than the
  ;; echo area (in the minibuffer).
  (eldoc-echo-area-prefer-doc-buffer 't)
  ;; Collects and displays all available documentation immediately, even if
  ;; multiple sources provide it. It concatenates the results.
  (eldoc-documentation-strategy #'eldoc-documentation-compose))

(use-package eglot
  :ensure nil ;; built-in
  :defer t
  :after (eldoc)
  :bind (:map eglot-mode-map
         ("C-h ." . #'onghaik/eldoc-doc-buffer) ;; Override the default binding
         ("C-c h ." . #'onghaik/eldoc-doc-buffer)
         ;; Rebind eldoc to something else I use less often. eldoc will open
         ;; the buffer, but then not switch to it, just leaving it open to stare at.
         ("C-c h ?" . #'eldoc)
         ("C-h >" . #'onghaik/close-eldoc-doc-buffer))
  ;; :hook (((c-mode c++-mode c-ts-mode c++-ts-mode rust-mode rust-ts-mode
  ;;          scala-mode scala-ts-mode python-mode python-ts-mode qml-ts-mode) . eglot-ensure))
  :hook (((python-mode python-ts-mode) . eglot-ensure))
  :config
  (fset #'jsonrpc--log-event #'ignore)  ; massive perf boost---don't log every event
  ;; (add-to-list
  ;;  'eglot-server-programs
  ;;  `((scala-ts-mode scala-mode) . ,(eglot-alternatives
  ;;                                   '("metals" "metals-emacs"))))
  :custom
  ;; When no buffers are connected to an LSP server, shut down the server and
  ;; eglot, to lighten the load on Emacs.
  (eglot-autoshutdown t)
  ;; For performance, set this to a low number. When debugging, comment this out.
  ;; Setting to 0 means no messages/events are logged in the EGLOT events buffer.
  ;; NOTE: In eglot 1.16, this variable was deprecated! If you still want to set
  ;; the events buffer size to 0, you need the following:
  ;; (setf (plist-get eglot-events-buffer-config :size) 0)
  (eglot-events-buffer-size 0)
  ;; For performance, set this to ignore. When debugging, comment this out.
  ;; fset-ing to ignore means no jsonrpc event are logged by Emacs.
  (fset #'jsonrpc--log-event #'ignore)
  ;; XRef look-ups can leave the project Eglot is running a server for
  (eglot-extend-to-xref t)
  ;; Wait some number of seconds before waiting for the connection to the LSP.
  ;; With nil, do not wait to connect at all, just try to connect immediately.
  (eglot-sync-connect nil)
  ;; Reduce the amount of time required for eglot to time-out LSP server
  ;; connection attempts.
  (eglot-connect-timeout 10)
  (eglot-ignored-server-capabilities
   '(;; Disable LSP from providing highlighting, since I use treesitter-based or
     ;; Emacs' built-in regexp-based major modes for font-locking.
     :colorProvider
     :documentHighlightProvider
     :foldingRangeProvider
     ;; Disable inline/inlay hints (for function parameters for example).
     ;; The way Emacs handles them makes lines very long and a bit annoying to
     ;; read. I also don't find them that helpful.
     :inlayHintProvider))
  (eglot-stay-out-of '(yasnippet))
  (eglot-workspace-configuration
   '((:pylsp . (:configurationSources ["flake8"]
                :plugins (:pycodestyle (:enabled :json-false)
                          :mccabe (:enabled :json-false)
                          :pyflakes (:enabled :json-false)
                          :flake8 (:enabled :json-false
                                            :maxLineLength 88)
                          :ruff (:enabled t :lineLength 88)
                          :pydocstyle (:enabled t :convention "numpy")
                          :yapf (:enabled :json-false)
                          :autopep8 (:enabled :json-false)
                          :black (:enabled t :line_length 88
                                           :cache_config t)))))))

;; (or (getenv "GUIX_ENVIRONMENT")
;;     (getenv "IN_NIX_SHELL"))


(provide 'lsp-config)
;;; lsp-config.el ends here
