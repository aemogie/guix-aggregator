;;; dashboard.el --- Dashboard for Emacs -*- lexical-binding: t -*-

;; Copyright (C) 2025 Josep Bigorra

;; Author: Josep Bigorra <jjbigorra@gmail.com>
;; Maintainer: Josep Bigorra <jjbigorra@gmail.com>
;; URL: https://codeberg.org/jjba23/sss

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

;; Dashboard for Emacs

;;; Code:

;; TODO the bookmarks should be managed by SSS in Scheme and not in Emacs
(defvar joe-bookmarks-personal)
(setq joe-bookmarks-personal
      `((("sss" . ,(string-replace "$HOME" "~" sss-clone-dir))
         ("emacs cfg" . ,(format "%s/lib/emacs/init.el" (string-replace "$HOME" "~" sss-clone-dir)))
         ("hyprland" . ,(format "%s/lib/hyprland/" (string-replace "$HOME" "~" sss-clone-dir))))
        (("notes" . "~/Ontwikkeling/Persoonlijk/private-notes/")
         ("pop-test" . "~/Ontwikkeling/Persoonlijk/pop-test/")
         ("iter-vitae" . "~/Ontwikkeling/Persoonlijk/iter-vitae/")
         ("jointhefreeworld" . "~/Ontwikkeling/Persoonlijk/jointhefreeworld/"))
        (("wolk-jjba" . "~/Ontwikkeling/Persoonlijk/wolk-jjba/")
         ("wikimusic" . "~/Ontwikkeling/Persoonlijk/wikimusic/")
         ("lucidplan" . "~/Ontwikkeling/Persoonlijk/lucidplan/")
         ("byggsteg" . "~/Ontwikkeling/Persoonlijk/byggsteg/"))))

(defvar joe-bookmarks-work)
(setq joe-bookmarks-work
      '((("VDB" . "~/Ontwikkeling/Werk/Vandebron/")
         ("onboarding" . "~/Ontwikkeling/Werk/onboarding/"))          
        ))

(use-package welkomscherm
  :ensure (:host codeberg :repo "jjba23/welkomscherm.el" :branch "trunk")
  :bind (("C-c SPC SPC" . welkomscherm)
         )
  :init
  (setq welkomscherm-bookmarks-personal joe-bookmarks-personal)
  (setq welkomscherm-bookmarks-work joe-bookmarks-work)

  (setq welkomscherm-buttons-actions
        '((("*scratch*" . (lambda(btn) (switch-to-buffer "*scratch*")))
           ("*Messages*" . (lambda(btn) (switch-to-buffer "*Messages*")))
           ("re-render me" . (lambda(btn) (welkomscherm))))
          (("system-rebuild  (sr)" . (lambda(btn) (sss-sys-reconfigure)))
           ("joe-rebuild (jr)" . (lambda(btn) (sss-joe-reconfigure))))
          )))

(provide 'sss/dashboard)

;;; dashboard.el ends here
