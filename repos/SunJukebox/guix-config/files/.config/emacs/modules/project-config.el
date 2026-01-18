;;; project-config.el --- Provides and configures project.el for my needs -*- lexical-binding: t -*-
;;; Commentary:
;;
;; project.el gives us a nice way to move through and around projects.
;; project.el will automatically recognize most version-controlled directories
;; as projects.
;; It works particularly well with Git.
;;
;; See Emacs's internal documentation (emacs) Projects for further details about
;; project.el.
;;
;;; Code:

(require 'magit-config)

(use-package xref
  :ensure nil
  :defer nil)

(use-package project
  :ensure nil ; built-in
  :defer nil
  ;; :requires (xref)
  :after (magit)
  :bind (:map
         project-prefix-map
         ("m" . magit-project-status))
         ;; ("V" . project-vterm))
  :init
  ;; NOTE: The `project-vterm' function is copied & modified directly from the
  ;; source for `project-shell'.
  (defun project-vterm ()
    "Start an inferior vterm in the current project's root directory.
If a buffer already exists for running a vterm in the project's root,
switch to it.  Otherwise, create a new vterm buffer.
With \\[universal-argument] prefix arg, create a new inferior vterm buffer even
if one already exists."
    (interactive)
    (require 'project)
    (require 'comint)
    (require 'vterm)
    (let* ((default-directory (project-root (project-current t)))
           (default-project-vterm-name (project-prefixed-buffer-name "vterm"))
           (vterm-buffer (get-buffer default-project-vterm-name)))
      (if (and vterm-buffer (not current-prefix-arg))
          (if (comint-check-proc vterm-buffer)
              (pop-to-buffer vterm-buffer
                             (bound-and-true-p display-comint-buffer-action))
            (vterm vterm-buffer))
        (vterm (generate-new-buffer-name default-project-vterm-name)))))
  :custom
  ;; Add magit-status as a possible project.el keybinding
  ;; (keymap-set project-prefix-map "m" #'magit-project-status)
  (add-to-list 'project-switch-commands '(magit-project-status "Magit") t)
  ;; Add ability to spawn vterm instances using project.el
  ;; (keymap-set project-prefix-map "V" #'project-vterm)
  (add-to-list 'project-switch-commands '(project-vterm "Vterm") t))

(defun project-whitespace-cleanup-project-files ()
  "Run `whitespace-cleanup' on all project files.
NOTE: This will also close your currently open buffer if you are visiting a file
in the project."
  (interactive)
  (require 'project)
  (dolist (file-path (project-files (project-current)))
    (let* ((buffer (find-file-noselect file-path)))
      (when buffer
        (with-current-buffer buffer
          (whitespace-cleanup)
          (save-buffer)
          (kill-buffer))))))

(provide 'project-config)
;;; project-config.el ends here
