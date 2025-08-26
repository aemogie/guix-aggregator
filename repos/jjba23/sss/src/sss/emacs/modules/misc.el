;;; misc.el --- Misc configuration for Emacs -*- lexical-binding: t -*-

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

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

;; Misc configuration for Emacs

;;; Code:

(use-package prodigy
  :ensure t)

(use-package git-riddance
  :ensure (:host codeberg :repo "jjba23/git-riddance.el" :branch "trunk"))

(use-package dagboek
  :ensure (:host codeberg :repo "jjba23/dagboek.el" :branch "trunk")
  :bind (("C-c ; v" . dagboek-today-entry)
         ("C-c ; g" . dagboek-yesterday-entry))
  :custom
  (dagboek-entry-location "~/hacking/private-notes/diary"))

(use-package gptel
  :ensure t
  :after (f)
  :config
  (setq
   gptel-model 'gemini-pro
   gptel-backend (gptel-make-gemini "Gemini"
                                    :key (lambda() (f-read-text "~/.secrets/gemini"))
                                    :stream t)))


(use-package speed-type
  :ensure (:host github :repo "dakra/speed-type"))

(use-package guix :ensure t :demand t)

(use-package pandoc-mode :ensure t)

(use-package jinx
  :ensure nil
  :demand t
  :bind (("M-$" . jinx-correct)
         ([remap ispell-word] . #'jinx-correct)
         ("C-M-$" . jinx-languages))
  :init
  (setq jinx-languages "en_US nl_NL")
  :config
  (dolist (hook '(text-mode-hook
                  prog-mode-hook
                  conf-mode-hook
                  org-mode-hook
                  markdown-mode-hook))
    (add-hook hook #'jinx-mode)))

(use-package gnuplot
  :ensure t)


(provide 'sss/misc)

;;; misc.el ends here
