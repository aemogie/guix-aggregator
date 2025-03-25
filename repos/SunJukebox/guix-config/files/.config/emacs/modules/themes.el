;;; themes.el --- Module for emacs theme package and configuration.  -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Kyle O.

;; Author: Kyle O. <kyle@oldcoal>
;; Keywords: themes

(add-to-list 'package-selected-packages 'doom-themes)

;; doom-themes
;; Global settings (defaults)
(customize-set-variable 'doom-themes-enable-bold t)    ; if nil, bold is universally disabled
(customize-set-variable 'doom-themes-enable-italic t) ; if nil, italics is universally disabled
(load-theme 'doom-one t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)
;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(customize-set-variable 'doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
(doom-themes-treemacs-config)
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)
