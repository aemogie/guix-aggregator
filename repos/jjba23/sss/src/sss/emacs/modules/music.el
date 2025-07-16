;;; music.el --- Music configuration for Emacs -*- lexical-binding: t -*-

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

;; Music configuration for Emacs

;;; Code:

(use-package fretboard
  :ensure (:host github :repo "vifon/fretboard.el" :branch "master"))

(use-package smudge
  :ensure t
  :after (f)
  :custom
  (smudge-oauth2-client-secret (f-read-text "~/secrets/smudge-oauth2-client-secret"))
  (smudge-oauth2-client-id (f-read-text "~/secrets/smudge-oauth2-client-id"))
  (smudge-player-use-transient-map t)
  :config
  (define-key smudge-mode-map (kbd "C-c .") 'smudge-command-map))

(use-package emms
  :ensure t
  :init
  (require 'emms-setup)
  (require 'emms-mpris)
  (emms-all)
  (emms-default-players)
  (emms-mpris-enable)
  :custom
  (emms-source-file-default-directory sss-ews-music-directory)
  (emms-browser-covers #'emms-browser-cache-thumbnail-async)
  :bind
  (("<f5>"   . emms-browser)
   ("M-<f5>" . emms)
   ("<XF86AudioPrev>" . emms-previous)
   ("<XF86AudioNext>" . emms-next)
   ("<XF86AudioPlay>" . emms-pause)))

(provide 'sss/music)

;;; music.el ends here
