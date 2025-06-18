;;; SSS - Supreme Sexp System

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

(in-package #:nyxt-user)

;; We need Quicklisp (more details at https://quicklisp.org) to load external packages
;; in a Common Lisp project:
;;     cd ~ && curl -O https://beta.quicklisp.org/quicklisp.lisp
;;     sbcl --load quicklisp.lisp
;; then in the REPL:
;;     (quicklisp-quickstart:install)
;;     (quit)
;; then we are ready to load quicklisp
(load "~/quicklisp/setup.lisp")

(defvar *my-search-engines*
  (list
   (make-instance 'search-engine :name "Wikipedia" :shortcut "wiki" :search-url
                  "https://en.wikipedia.org/w/index.php?search=~a"
                  :fallback-url (quri.uri:uri "https://en.wikipedia.org/"))
   (make-instance 'search-engine :name "Google" :shortcut "goo" :search-url
                  "https://google.com/?search=~a" :fallback-url
                  (quri.uri:uri "https://google.com/"))
   (make-instance 'search-engine :name "DuckDuckGo" :shortcut "ddg" :search-url
                  "https://duckduckgo.com/?q=~a" :fallback-url
                  (quri.uri:uri "https://duckduckgo.com/"))))

(defmethod files:resolve ((profile nyxt:nyxt-profile) (file nyxt/mode/bookmark:bookmarks-file))
  "Reroute the bookmarks to the config directory."
  #p"~/.config/nyxt/bookmarks.lisp")

(unless nyxt::*run-from-repl-p*
  (define-configuration :browser
    "Enable Nyxt-internal debugging, but only in binary mode and after startup if done.
There are conditions raised at startup, and I don't want to catch
those, hanging my Nyxt)."
    ((after-startup-hook (hooks:add-hook %slot-value% #'toggle-debug-on-error)))))

(define-configuration buffer
    ((search-engines (append %slot-default%
                             *my-search-engines*))))

(define-configuration (:modable-buffer :prompt-buffer :editor-buffer)
  "Set up Emacs keybindings everywhere possible."
  ((default-modes `(:emacs-mode ,@%slot-value%))))

(define-configuration :web-buffer
  "Basic modes setup for web-buffer."
  ((default-modes `(:emacs-mode
                    :blocker-mode :force-https-mode
                    :reduce-tracking-mode
                    :certificate-exception-mode                    
                    :user-script-mode :bookmarklets-mode
                    nyxt/mode/blocker:blocker-mode
                    nyxt/mode/reduce-tracking:reduce-tracking-mode
                    ,@%slot-value%))))

(define-configuration :browser
  "Set new buffer URL (a.k.a. start page, new tab page)."
  ((default-new-buffer-url (quri:uri "nyxt:nyxt/mode/repl:repl"))
   (remote-execution-p t)
   (external-editor-program
    (list "emacsclient" "-cn" "-a" "" "-F"
          "((vertical-scroll-bars) (tool-bar-lines) (menu-bar-lines))"))))

(define-configuration :status-buffer
  "Display modes as short glyphs."
  ((glyph-mode-presentation-p t)))

(define-configuration :force-https-mode ((glyph "ϕ")))
(define-configuration :user-script-mode ((glyph "u")))
(define-configuration :blocker-mode ((glyph "β")))
(define-configuration :proxy-mode ((glyph "π")))
(define-configuration :reduce-tracking-mode ((glyph "τ")))
(define-configuration :certificate-exception-mode ((glyph "χ")))
(define-configuration :style-mode ((glyph "ϕ")))
(define-configuration :cruise-control-mode ((glyph "σ")))

(defmethod format-status-load-status ((status status-buffer))
  "A fancier load status."
  (spinneret:with-html-string
      (:span (if (and (current-buffer)
                      (web-buffer-p (current-buffer)))
                 (case (slot-value (current-buffer) 'nyxt::status)
                   (:unloaded "∅")
                   (:loading "∞")
                   (:finished ""))
                 ""))))
