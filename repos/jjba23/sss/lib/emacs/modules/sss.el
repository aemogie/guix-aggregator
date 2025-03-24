;;; sss.el --- SSS configuration for Emacs -*- lexical-binding: t -*-

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

;; SSS configuration for Emacs

;;; Code:

(defgroup sss ()
  "SSS customization group."
  :group 'tools)

(defcustom sss-font-mono "Adwaita Mono"
  "My personal choice for monospaced font family." 
  :type 'string)

(defcustom sss-font-sans "Inter"
  "My personal choice for sans font family." 
  :type 'string)

(defcustom sss-ews-music-directory "~/Muziek"
  "My personal main directory where to read music from."
  :type 'string)

(defcustom sss-clone-dir nil
  "The directory where the SSS (Supreme Sexp System) source code is located."
  :type 'string)

(defcustom sss-notes-roam-dir nil
  "The directory where the Org roam notes should be stored."
  :type 'string)

(defcustom sss-emacs-theme nil
  "The name of the Emacs theme to use, acording to SSS palette."
  :type 'symbol)

(provide 'sss/sss)

;;; sss.el ends here
