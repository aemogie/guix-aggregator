;;; anon-ide-config.el --- Provide configuration to make Emacs more IDE-like  -*- lexical-binding: t; -*-

;; Copyright (C) 2025  

;; Author:  <kyle@thinkpad490>
;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(use-package yasnippet
  :hook ((text-mode
          prog-mode
          conf-mode
          snippet-mode) . yas-minor-mode-on)
  :init
  (customize-set-variable 'yas-snippet-dirs (list (expand-file-name "snippets" user-emacs-directory))))

(provide 'anon-ide-config)
;;; anon-ide-config.el ends here
