;;; early-init.el --- Custom Emacs configuration for SSS -*- lexical-binding: t -*-

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

;; TODO

;;; Code:

;; disable Emacs' built-in package manager (in favor of Elpaca)
(setq package-enable-at-startup nil)

;; temporarily increase GC threshold at startup
(setq gc-cons-threshold most-positive-fixnum)

;; restore threshold to normal value after startup
(add-hook 'emacs-startup-hook
          (lambda() (setq gc-cons-threshold (* 50 1024 1024))))

;; hide certain UI elements of Emacs
;; which are not that interesting for power users
;;
;; if you're a beginner, consider setting these to 1
;;
(tool-bar-mode -1) 
(scroll-bar-mode -1) 
(menu-bar-mode -1)

(setq inhibit-startup-message t
      inhibit-startup-screen t)

;; tweak native compilation settings
(setq native-comp-speed 2)
