;;; init.el --- Crafted Emacs Base Example -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initial phase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Tell Emacs where to look for my other config files
(defvar user-emacs-config-directory (concat user-emacs-directory "modules/")
  "Variable for this user's configuration directory.")

;; user-emacs-directory + "config/" to put the config directory in the load-path
(add-to-list 'load-path (expand-file-name "modules/" user-emacs-directory))

;; Load in my package list
(require 'package-config)

;; Don't litter file system with *~ backup files; put them all inside
;; user-emacs-directory + "emacs-backup/"
(defun onghaik/backup-file-name (FPATH)
  "Return a new file path of a given file path (FPATH).  If the new path's directories does not exist, create them."
  (let* ((backupRootDir (concat user-emacs-directory "emacs-backup/"))
         (filePath (replace-regexp-in-string "[A-Za-z]:" "" FPATH )) ; remove Windows driver letter in path
         (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") )))
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'onghaik/backup-file-name)

;; Load the custom file if it exists.  Among other settings, this will
;; have the list `package-selected-packages', so we need to load that
;; before adding more packages.  The value of the `custom-file'
;; variable must be set appropriately, by default the value is nil.
;; This can be done here, or in the early-init.el file.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;; Bootstrap crafted-emacs in init.el
;; Adds crafted-emacs modules to the `load-path', sets up a module
;; writing template, sets the `crafted-emacs-home' variable.
;; (load (expand-file-name "../../modules/crafted-init-config"
;;                         user-emacs-directory))
;; Adjust the path (e.g. to an absolute one)
;; depending where you cloned Crafted Emacs.
;; (load "$HOME/src/crafted-emacs/modules/crafted-init-config")

;; Save all customizations (initialization and selected packages) to
;; `custom-file', unless the user opted out.
(add-hook 'after-init-hook
          (lambda ()
            (customize-save-customized)
            (package--save-selected-packages package-selected-packages)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Packages phase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Collect list of packages to install.  This phase is not needed if
;; manage the installed packages with Guix or Nix.  It is also not
;; needed if you do not need to install packages for a
;; module.

;; Add package definitions for completion packages
;; to `package-selected-packages'.
(require 'rainbow-delimiters-packages)
(require 'project-packages)
(require 'markdown-packages)
(require 'magit-packages)
(require 'navigation-packages)
(require 'completion-packages)
(require 'yasnippet-packages)
(require 'tex-packages)
;; (require 'anon-core-packages)
;; (require 'anon-ide-packages)
;; (require 'crafted-completion-packages)
;; (require 'crafted-ide-packages)
;; (require 'crafted-lisp-packages)
;; (require 'crafted-org-packages)
;; (require 'crafted-ui-packages)
;; (require 'crafted-workspaces-packages)
;; (require 'crafted-writing-packages)

;; Install the packages listed in the `package-selected-packages' list.
(package-install-selected-packages :noconfirm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Configuration phase
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Modules to configure Emacs.

(require 'personal-settings)
(require 'dired-config)
(require 'comint-config)
(require 'theme-config)
(require 'project-config)
(require 'magit-config)
(require 'navigation-config)
(require 'completion-config)
(require 'vterm-config)
(require 'yasnippet-config)
(require 'tex-config)
(require 'lsp-config)
(require 'treesit-config)
;; (require 'anon-core-config)
;; (require 'anon-defaults)
;; (require 'anon-ide-config)
;; (require 'anon-keys-meow)
;; (require 'anon-latex-config)
;; (require 'crafted-completion-config)
;; (require 'crafted-ide-config)
;; (require 'crafted-lisp-config)
;; (require 'crafted-org-config)
;; (require 'crafted-ui-config)
;; (require 'crafted-workspaces-config)
;; (require 'crafted-writing-config)
;; (require 'crafted-defaults-config)
;; (require 'crafted-speedbar-config)
;; (require 'crafted-startup-config)

;; Profile emacs startup
(defun onghaik/display-startup-time ()
  "Display the startup time after Emacs is fully initialized."
  (message "Emacs loaded in %s."
           (emacs-init-time)))
(add-hook 'emacs-startup-hook #'onghaik/display-startup-time)

;; Set default coding system (especially for Windows)
(set-default-coding-systems 'utf-8)

;; If Emacs has been idle for 15+ seconds, perform a GC run.
;; From https://akrl.sdf.org/#orgc15a10d
(run-with-idle-timer 15 t #'garbage-collect)

(provide 'init)
;;; init.el ends here
