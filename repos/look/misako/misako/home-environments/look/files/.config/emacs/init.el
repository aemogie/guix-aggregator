(use-package emacs
  :hook ((prog-mode text-mode conf-mode
          emacs-lisp-mode) . electric-pair-local-mode)
  :init
  (load-file "~/.config/emacs/theme.el")
  (load-file "~/.config/emacs/guix.el")
  (load-file "~/.config/emacs/editor.el")
  :config
  (which-key-mode 1)
  (vertico-mode 1)
  (save-place-mode 1)
  ;; Disable useless buffers
  (setq-default message-log-max nil)
  (kill-buffer "*Messages*")
  (kill-buffer "*scratch*")
  (add-hook 'minibuffer-exit-hook
            '(lambda ()
               (let ((buffer "*Completions*"))
                 (and (get-buffer buffer)
                      (kill-buffer buffer)))))
  :custom
  (user-emacs-directory "~/.config/emacs")
  (user-full-name "{{{ aerc.primary.name }}}")
  (user-mail-address "{{{ aerc.primary.email }}}")
  ;; Fix emacs backup files in directories
  (backup-directory-alist
   `((".*" . ,(expand-file-name "backups" user-emacs-directory))))
  (auto-save-file-name-transforms
   `((".*" ,(expand-file-name "autosave/" user-emacs-directory) t)))
  (make-backup-files    nil)
  (create-lockfiles     nil)
  (backup-by-copying    t)
  (version-control      t)
  (delete-old-versions  t)
  (vc-make-backup-files t)
  (kept-old-versions    10)
  (kept-new-versions    10)
  ;; Keep M-x history
  (smex-save-file "~/.cache/.smex-items")
  ;; Set initial scratch buffer message
  (initial-scratch-message ""))

(use-package parinfer-rust-mode
  :hook ((emacs-lisp-mode scheme-mode) . parinfer-rust-mode)
  :config
  (add-to-list 'auto-mode-alist '("\\.scm\\'" . scheme-mode))
  (setq-default indent-tabs-mode nil)
  :custom
  (parinfer-rust-disable-troublesome-modes t))

(use-package tabspaces
  :init
  (tab-bar-rename-tab "Home")
  (when (get-buffer "*Messages*")
    (set-frame-parameter nil
                         'buffer-list
                         (cons (get-buffer "*Messages*")
                               (frame-parameter nil 'buffer-list))))
  (when (get-buffer "*splash*")
    (set-frame-parameter nil
                         'buffer-list
                         (cons (get-buffer "*splash*")
                               (frame-parameter nil 'buffer-list))))
  :hook (after-init . tabspaces-mode)
  :commands (tabspaces-switch-or-create-workspace
             tabspaces-open-or-create-project-and-workspace)
  :custom
  (tabspaces-session-project-session-store 'project)
  (tabspaces-use-filtered-buffers-as-default t)
  (tabspaces-include-buffers '())
  (tabspaces-initialize-project-with-todo t)
  (tabspaces-todo-file-name "project-todo.org")
  (tabspaces-session t)
  (tabspaces-session-auto-restore nil)
  (tab-bar-new-tab-choice "*scratch*"))

(use-package activities
  :init
  (activities-mode)
  (activities-tabs-mode))

(use-package eglot
  :hook ((after-init) . eglot-ensure)
  :custom
  (flymake-show-diagnostics-at-end-of-line t))
