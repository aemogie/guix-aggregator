;;; init.el --- Crafted Emacs Base Example -*- lexical-binding: t; -*-

;; Copyright (C) 2023
;; SPDX-License-Identifier: MIT

;; Author: System Crafters Community

;;; Commentary:

;; Base example init.el (extended from the info file).
;; Basic example of loading a module.

;;; Code:

;; Initial phase

;; Load the custom file if it exists.  Among other settings, this will
;; have the list `package-selected-packages', so we need to load that
;; before adding more packages.  The value of the `custom-file'
;; variable must be set appropriately, by default the value is nil.
;; This can be done here, or in the early-init.el file.
;; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; (when (and custom-file
;;            (file-exists-p custom-file))
;;   (load custom-file nil :nomessage))

;; Bootstrap crafted-emacs in init.el
;; Adds crafted-emacs modules to the `load-path', sets up a module
;; writing template, sets the `crafted-emacs-home' variable.
;; (load (expand-file-name "../../modules/crafted-init-config"
;;                         user-emacs-directory))
;; Adjust the path (e.g. to an absolute one)
;; depending where you cloned Crafted Emacs.
(load "$HOME/src/crafted-emacs/modules/crafted-init-config")

(add-to-list 'load-path (expand-file-name "modules"
                                          user-emacs-directory))

;;; Packages phase
;; Collect list of packages to install. Do not just blindly copy this
;; list, instead think about what you need and see if there is a
;; module which provides the list of packages needed. This phase is
;; not needed if manage the installed packages with Guix or Nix. It
;; is also not needed if you do not need Crafted Emacs to install
;; packages for a module, for example,
;; `crafted-speedbar-config' does not require any packages to
;; be installed.

;; Add package definitions for completion packages
;; to `package-selected-packages'.
(require 'crafted-completion-packages)
;; (require 'crafted-ide-packages)
(require 'crafted-lisp-packages)
(require 'crafted-org-packages)
;; (require 'crafted-ui-packages)
;; (require 'crafted-workspaces-packages)
;; (require 'crafted-writing-packages)

;; Additional packages
(add-to-list 'package-selected-packages 'meow)
(require 'anon-core-packages)
(require 'anon-ide-packages)
(require 'anon-latex-packages)

;; Install the packages listed in the `package-selected-packages' list.
(package-install-selected-packages :noconfirm)

;;; Configuration phase
;; Some example modules to configure Emacs. Don't blindly copy these,
;; they are here for example purposes. Find the modules which work
;; for you.

;; Load configuration for the completion module
(require 'crafted-completion-config)
;; (require 'crafted-ide-config)
(require 'crafted-lisp-config)
(require 'crafted-org-config)
;; (require 'crafted-ui-config)
;; (require 'crafted-workspaces-config)
;; (require 'crafted-writing-config)

;; Some more configurations that don't require packages to be installed
(require 'crafted-defaults-config)
;; (require 'crafted-speedbar-config)
;; (require 'crafted-startup-config)

;;; Additional configuration
(require 'anon-core-config)
(require 'anon-defaults)
(require 'anon-ide-config)
(require 'anon-keys-meow)
(require 'anon-latex-config)

;; Profile emacs startup
(defun anon/display-startup-time ()
  "Display the startup time after Emacs is fully initialized."
  (message "Emacs loaded in %s."
           (emacs-init-time)))
(add-hook 'emacs-startup-hook #'anon/display-startup-time)

;; Set default coding system (especially for Windows)
(set-default-coding-systems 'utf-8)

(provide 'init)
;;; init.el ends here
