;;; anon-packages.el --- Set up package.el and use-package  -*- lexical-binding: t; -*-

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

;; Set up package archives (configuring `package.el')
(load "$HOME/src/crafted-emacs/modules/crafted-early-init-config")

;; (package-initialize)
;; (unless package-archive-contents
;; (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Automatically install packages when not in Guix
;; (setq use-package-always-ensure (not anon/is-guix-system))

;; Never load a package until demanded or triggered
;; (setq use-package-always-defer t)

(provide 'anon-packages)
;;; anon-packages.el ends here
