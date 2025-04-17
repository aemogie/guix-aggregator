;;; eglot.el --- Eglot configuration for Emacs -*- lexical-binding: t -*-

;; Copyright (C) 2025 Josep Bigorra

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Eglot configuration for Emacs

;;; Code:

(use-package eglot
  :ensure nil
  :hook ((scala-ts-mode . eglot-ensure)
	 (sh-mode . eglot-ensure)
	 (haskell-mode . eglot-ensure)
	 (markdown-mode . eglot-ensure)
         (nix-ts-mode . eglot-ensure)
         (go-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (rust-mode . eglot-ensure)
         (yaml-mode . eglot-ensure)
         (yaml-ts-mode . eglot-ensure)
         (before-save . eglot-format-buffer))
  :bind (("C-c i i" . eglot-find-implementation)
	 ("C-c i e" . eglot)
	 ("C-c i k" . eglot-shutdown-all)
	 ("C-c i r" . eglot-rename)
	 ("C-c i x" . eglot-reconnect)
	 ("C-c i a" . eglot-code-actions)
	 ("C-c i m" . eglot-menu)
	 ("C-c i f" . eglot-format-buffer)
	 ("C-c i h" . eglot-inlay-hints-mode))
  :init
  (setq eglot-autoshutdown t
        eglot-confirm-server-edits nil
        eglot-report-progress t
        eglot-extend-to-xref t
        eglot-autoreconnect t)
  :config
  (setq eglot-server-programs (assq-delete-all 'scala-mode eglot-server-programs))
  (add-to-list 'eglot-server-programs '(scala-mode . ("metals" "-Dmetals.http=on")))
  (add-to-list 'eglot-server-programs '(scala-ts-mode . ("metals" "-Dmetals.http=on")))
  (add-to-list 'eglot-server-programs '(nix-ts-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(markdown-mode . ("marksman")))
  
  (setq-default eglot-workspace-configuration
                '(
                  :metals ( :autoImportBuild t
                            :superMethodLensesEnabled t
                            :showInferredType t
                            :enableSemanticHighlighting t
                            :inlayHints ( :inferredTypes (:enable t )
                                          :implicitArguments (:enable nil)
                                          :implicitConversions (:enable nil )
                                          :typeParameters (:enable t )
                                          :hintsInPatternMatch (:enable nil )))
                  :haskell (:formattingProvider "ormolu")
                  :rust-analyzer (:cargo (:sysroot "discover"
                                                   :features "all"
                                                   :buildScripts (:enable t))
                                         :diagnostics (:disabled ["macro-error"])
                                         :procMacro (:enable t))
                  :yaml ( :format (:enable t)
                          :validate t
                          :hover t
                          :completion t
                          :schemas (
                                    https://codeberg.org/jjba23/pop-test/raw/branch/trunk/resources/json-schema/pop-test.json ["golden-test.yaml" "golden-test.yml" "pop-test.yaml" "pop-test.yml"]
                                    https://raw.githubusercontent.com/Vandebron/gh-mpyl/refs/heads/main/src/mpyl/schema/project.schema.yml ["project.yml"]
                                    https://json.schemastore.org/yamllint.json ["/*.yml"])
                          :schemaStore (:enable t))
                  :nil (:formatting (:command ["nixfmt"]))))

  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              ;; Show flymake diagnostics first.
              (setq eldoc-documentation-functions
                    (cons #'flymake-eldoc-function
                          (remove #'flymake-eldoc-function eldoc-documentation-functions)))
              ;; Show all eldoc feedback.
              (setq eldoc-documentation-strategy #'eldoc-documentation-compose)))

  (setq python-flymake-command '("~/.local/bin/flake8" "-") )           
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (when (or (derived-mode-p 'python-mode)
                        (derived-mode-p 'python-ts-mode))
                (add-hook 'flymake-diagnostic-functions 
                          'python-flymake nil t)
                (flymake-start))))

  )


(provide 'sss/eglot)

;;; eglot.el ends here
