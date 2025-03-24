;;; buffers.el --- Buffers Configuration File -*- lexical-binding: t -*-
;;; Commentary:
;;; Divya's Emacs UI Configurations

;;; Code:

;;; Buffer Management
;; (use-package bufler
;;    :straight t
;;    :init (bufler-workspace-mode)
;;    :bind (("C-M-j" . bufler-switch-buffer)
;; 	 ("C-M-b" . bufler-mode)
;; 	 ("C-M-k" . bufler-workspace-frame-set))
;;    :general
;;    (divya/evil
;;      :keymaps 'bufler-list-mode-map
;;      :packages 'bufler
;;      "?" #'hydra:bufler/body
;;      "g" #'bufler
;;      "f" #'bufler-list-group-frame
;;      "N"   #'bufler-list-buffer-name-workspace
;;      "k"   #'bufler-list-buffer-kill
;;      "p"   #'bufler-list-buffer-peek
;;      "s"   #'bufler-list-buffer-save
;;      "RET" #'bufler-list-buffer-switch))


;;  (setf bufler-groups
;;        (bufler-defgroups
;; 	;; Subgroup collecting all named workspaces.
;; 	(group (auto-workspace))
;; 	;; Subgroup collecting buffers in a projectile project.
;; 	(group (auto-projectile))
;; 	;; Grouping browser windows
;; 	(group
;; 	 ;; Subgroup collecting all `help-mode' and `info-mode' buffers.
;; 	 (group-or "Help/Info"
;; 		   (mode-match "*Help*" (rx bos (or "help-" "helpful-")))
;; 		   ;; (mode-match "*Helpful*" (rx bos "helpful-"))
;; 		   (mode-match "*Info*" (rx bos "info-"))))
;; 	(group
;; 	 ;; Subgroup collecting all special buffers (i.e. ones that are not
;; 	 ;; file-backed), except `magit-status-mode' buffers (which are allowed to fall
;; 	 ;; through to other groups, so they end up grouped with their project buffers).
;; 	 (group-and "*Special*"
;; 		    (name-match "**Special**"
;; 				(rx bos "*" (or "Messages" "Warnings" "scratch" "Backtrace" "Pinentry") "*"))
;; 		    (lambda (buffer)
;; 		      (unless (or (funcall (mode-match "Magit" (rx bos "magit-status"))
;; 					   buffer)
;; 				  (funcall (mode-match "Dired" (rx bos "dired"))
;; 					   buffer)
;; 				  (funcall (auto-file) buffer))
;; 			"*Special*"))))
;; 	;; Group remaining buffers by major mode.
;; 	(auto-mode)))

;; (divya/leader-keys
;;   "bn" 'next-buffer
;;   "bb" 'previous-buffer
;;   "bl" 'consult-buffer
;;   "bk" 'quit-window)

;;; Emacs native buffer management

(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "C-x k") 'quit-window)


(provide 'buffers.el)

;;; buffers.el ends here
