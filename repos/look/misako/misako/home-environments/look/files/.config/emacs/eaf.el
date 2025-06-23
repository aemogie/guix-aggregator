;; init.el -*- lexical-binding: t; -*-

;; SPDX-License-Identifier: GPL-3.0-or-later
;; SPDX-FileCopyrightText: (c) 2024 antlers <antlers@illucid.net>

;;; Commentary:

;; Just runs EAF

;;; Code:


;;; Use-Package
'(:guix emacs-use-package)
(eval-when-compile
  (require 'use-package))

;; Setup `:guix` as a no-op use-package keyword
;; (It's pulled out by a stand-alone script.)
(push ':guix use-package-keywords)
(defun use-package-normalize/:guix (_ keyword args)
  (use-package-as-one (symbol-name keyword) args
    (lambda (label arg) '())))
(defun use-package-handler/:guix (name-symbol keyword archive-name rest state)
  (use-package-process-keywords name-symbol rest state))


;;; Packages with `use-package' extensions or no autoloads
(use-package dash :guix emacs-dash)


;;; Helper Functions
(defun antlers/append-to-path (dir &optional path)
  (let ((path (or path "PATH")))
    (when (file-directory-p dir)
      (setenv path
        (-> (getenv path)
          (parse-colon-path)
          (append (list dir))
          (delete-dups)
          (string-join ":")))
      (when (string-equal path "PATH")
        (add-to-list 'exec-path dir))
      (getenv path))))


;; EAF
(use-package eaf
  :guix (alsa-lib
         at-spi2-core
         bzip2
         cairo
         cups
         dbus
         gcc-toolchain
         gdk-pixbuf
         glib
         gst-plugins-base
         gstreamer
         gtk+
         jq
         libinput
         libxcomposite
         libxkbcommon
         libxkbfile
         libxrandr
         libxrender
         libxtst
         nvda
         mit-krb5
         mysql
         node
         nss
         pango
         patchelf
         pcsc-lite
         postgresql
         pulseaudio
         python
         python-pyqt
         python-sexpdata
         python-epc
         speech-dispatcher
         unixodbc
         wmctrl
         xcb-util-cursor
         xcb-util-image
         xcb-util-keysyms
         xcb-util-wm
         xdotool)
  :load-path "~/.config/emacs/site-lisp/emacs-application-framework"
  :config
  ;; Gonna use the built-in Qt6 distribution, tried the `qtbase` package but got this error:
  ;; `libQt6Quick.so.6: undefined symbol: _ZTVNSt3pmr25monotonic_buffer_resourceE, version Qt_6`
  ;; Update: Still works if I comment this out, so I don't think it's needed >u<
  ;; (setenv "QT_QPA_PLATFORM_PLUGIN_PATH"
  ;;   (concat (getenv "HOME")
  ;;           "/.local/lib/python3.10/site-packages/PyQt6/Qt6/plugins/platforms"))
  (antlers/append-to-path
    (concat (getenv "GUIX_ENVIRONMENT") "/lib")
    "LD_LIBRARY_PATH")
  (antlers/append-to-path
    (concat (getenv "GUIX_ENVIRONMENT") "/lib/nss")
    "LD_LIBRARY_PATH")
  (let* ((sh-bin (shell-command-to-string "which sh"))
         (sh-bin (shell-command-to-string (concat "realpath " sh-bin)))
         (interpreter (shell-command-to-string (concat "patchelf --print-interpreter " sh-bin)))
         (interpreter (string-trim-right interpreter)))
      (-map (lambda (file)
              (call-process-shell-command
                (concat "patchelf --set-interpreter " interpreter " " (concat (getenv "HOME") file))
                nil 0))
        '("/.local/lib/python3.10/site-packages/PyQt6/Qt6/libexec/QtWebEngineProcess"
          "/.local/lib/python3.10/site-packages/PyQt6/Qt6/lib/libQt6Core.so.6"))))

;; These seem to work without additional deps
;; (though I haven't isolated them to be sure)
(use-package eaf-browser)
(use-package eaf-markdown-previewer)
; (use-package eaf-pdf-viewer)
; (use-package eaf-music-player)
; (use-package eaf-video-player)
; (use-package eaf-image-viewer)
; (use-package eaf-rss-reader)
; (use-package eaf-org-previewer)
; (use-package eaf-git)
; (use-package eaf-demo)
; (use-package eaf-pyqterminal
; (use-package eaf-mindmap)
; (use-package eaf-org-previewer)
; (use-package eaf-pdf-viewer)
; (use-package eaf-vue-demo)
; (use-package eaf-vue-tailwindcss)

;; These needed some python deps
; (use-package eaf-system-monitor
;   :guix python-psutil)
; (use-package eaf-file-manager
;   :guix python-pygments)
; (use-package eaf-jupyter
;   :guix python-qtconsole)

;; Block-cursor covers up letters, I'll stick to eshell.
;; (use-package eaf-pyqterminal
;;   :guix python-pyte)

;; And I haven't ran these:

;; Empty buffer
;; I get this error when trying to run any EAF application with `qtwebchannel` installed:
;; ImportError: /home/antlers/.local/lib/python3.10/site-packages/PyQt6/Qt6/lib/libQt6Core.so.6: version `Qt_6.6' not found (required by /gnu/store/2q6hy1pbhmylf3x0552xp47wsn3wl4n8-profile/lib/libQt6WebChannel.so.6)
;; (use-package eaf-camera
;;   :guix (;; qtwebchannel
;;          python-pyqt
;;          ))

;; `filebrowser` has not been packaged
;; (use-package eaf-file-browser
;;   :guix (filebrowser
;;          python-qrcode))

;; `python-unidiff` has not been packaged
;; (use-package eaf-git
;;   :guix (python-charset-normalizer
;;          python-pygit2
;;          ;; python-unidiff
;;          ))

; (setq eaf-browser-dark-mode "force")
(setq eaf-browser-translate-language "en")
(setq eaf-browser-continue-where-left-off t)
(setq eaf-browser-enable-adblocker t)
(setq eaf-browser-download-path "~/downloads")
(setq eaf-browser-default-search-engine "duckduckgo")
