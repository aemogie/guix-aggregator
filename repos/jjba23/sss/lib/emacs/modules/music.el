;;; music.el --- Music configuration for Emacs -*- lexical-binding: t -*-

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

(provide 'sss/music)

;;; music.el ends here
