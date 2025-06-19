;;; dashboard.el --- Dashboard for Emacs -*- lexical-binding: t -*-

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

;; Dashboard for Emacs

;;; Code:

;; TODO? the bookmarks could be managed by SSS in Scheme and not in Emacs?
(defvar joe-welkomscherm/bookmarks-list)
(setq joe-welkomscherm/bookmarks-list
      `((("sss" . ,(string-replace "$HOME" "~" sss-clone-dir))
         ("emacs cfg" . ,(format "%s/src/sss/emacs/init.el" (string-replace "$HOME" "~" sss-clone-dir)))
         ("hyprland" . ,(format "%s/src/sss/hyprland/" (string-replace "$HOME" "~" sss-clone-dir))))
        (("notes" . "~/hacking/private-notes/")
         ("pop-test" . "~/hacking/pop-test/")
         ("iter-vitae" . "~/hacking/iter-vitae/")
         ("jointhefreeworld" . "~/hacking/jointhefreeworld/"))
        (("wolk-jjba" . "~/hacking/wolk-jjba/")
         ("wikimusic" . "~/hacking/wikimusic/")
         ("lucidplan" . "~/hacking/lucidplan/")
         ("byggsteg" . "~/hacking/byggsteg/"))
        (("ggg" . "~/hacking/ggg")
         ("pingwing" . "~/hacking/pingwing")
         ("kracht" . "~/hacking/kracht")
         ("hygguile" . "~/hacking/hygguile"))
        (("orgwebalchemy" . "~/hacking/orgwebalchemy")
         ("oculuslambda" . "~/hacking/oculuslambda"))
        ))

(defvar joe-welkomscherm/work-list)
(setopt joe-welkomscherm/work-list
      '((("VDB" . "~/work/Vandebron/")
         ("mobile" . "~/work/mobile")
         ("onboarding" . "~/work/onboarding/"))          
        ))

(defvar joe-welkomscherm/actions-list)
(setopt joe-welkomscherm/actions-list
	'((("*scratch*" . (lambda(btn) (switch-to-buffer "*scratch*")))
           ("*Messages*" . (lambda(btn) (switch-to-buffer "*Messages*")))
           ("re-render me" . (lambda(btn) (welkomscherm))))
          (("system-rebuild  (sr)" . (lambda(btn) (sss-sys-reconfigure)))
           ("joe-rebuild (jr)" . (lambda(btn) (sss-joe-reconfigure))))
          ))

(use-package welkomscherm
  :ensure (:host codeberg :repo "jjba23/welkomscherm.el" :branch "trunk")
  :bind (("C-c SPC SPC" . welkomscherm)
         )
  :init
  (setopt welkomscherm/bookmarks-list joe-welkomscherm/bookmarks-list)
  (setopt welkomscherm/work-list joe-welkomscherm/work-list)
  (setopt welkomscherm/actions-list joe-welkomscherm/actions-list))

(provide 'sss/dashboard)

;;; dashboard.el ends here
