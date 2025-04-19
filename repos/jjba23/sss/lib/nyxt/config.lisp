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

;; Code:

(in-package #:nyxt-user)

;;; Reset ASDF registries to allow loading Lisp systems from
;;; everywhere.
#+nyxt-3 (reset-asdf-registries)

;;; Load quicklisp. Not sure it works.
#-quicklisp
(let ((quicklisp-init
       (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(ql:quickload :slynk)

(defvar *web-buffer-modes*
  '(:emacs-mode
    :blocker-mode :force-https-mode
    :reduce-tracking-mode
    :user-script-mode :bookmarklets-mode)
  "The modes to enable in any web-buffer by default.
Extension files are to append to this list.")

;;; Loading extensions and third-party-dependent configs. See the
;;; matching files for where to find those extensions.
(defmacro defextsystem (system &optional file)
  "Helper macro to load configuration for extensions.
Loads a newly-generated ASDF system depending on SYSTEM.
FILE, if provided, is loaded after the generated system successfully
loads."
  `(define-nyxt-user-system-and-load ,(gensym "NYXT-USER/")
                                     :depends-on (,system) ,@(when file
                                                               `(:components (,file)))))


(defvar *my-search-engines* nil)
(setf *my-search-engines*
      (list
       
       ;; '("quickdocs" "http://quickdocs.org/search?q=~a" "http://quickdocs.org/")
       '("wiki" "https://en.wikipedia.org/w/index.php?search=~a" "https://en.wikipedia.org/")
       ;; '("define" "https://en.wiktionary.org/w/index.php?search=~a" "https://en.wiktionary.org/")
       ;; '("python3" "https://docs.python.org/3/search.html?q=~a" "https://docs.python.org/3")
       ;; '("doi" "https://dx.doi.org/~a" "https://dx.doi.org/")
       '("duckduckgo" "https://www.duckduckgo.org/search?q=~a" "https://www.duckduckgo.org/")
       '("ecosia" "https://www.ecosia.org/search?method=index&q=~a" "https://www.ecosia.org/")
       ))

(define-configuration context-buffer
  "Go through the search engines above and make-search-engine out of them."
  ((search-engines
    (append %slot-default%
            (mapcar
             (lambda (engine) (apply 'make-search-engine engine))
             *my-search-engines*)))))

(define-configuration buffer
  ((override-map (define-key %slot-default%
                   "M-x" 'execute-command
                   "M-s l" 'search-buffer
                   "C-x left" 'history-backwards
                   "C-x right" 'history-forwards))))

(define-configuration browser
  ((remote-execution-p t)
   (theme theme:+dark-theme+ :doc "Setting dark theme.
The default is theme:+light-theme+.")
   (external-editor-program
    (list "emacsclient" "-c" "-a" "" "-F"
          "((font . \"Adwaita Mono-16\") (vertical-scroll-bars) (tool-bar-lines) (menu-bar-lines))"))
   (search-engines (append (mapcar (lambda (x)
				     (make-instance 'search-engine
						:shortcut (first x)
						:search-url (second x)
						:fallback-url (third x)))
				   *my-search-engines*)
                           %slot-default))))

;;; Those are settings that every type of buffer should share.
(define-configuration (:modable-buffer :prompt-buffer :editor-buffer)
  "Set up Emacs keybindings everywhere possible."
  ((default-modes `(:emacs-mode ,@%slot-value%))))

(define-configuration :prompt-buffer
  "Make the attribute widths adjust to the content in them.

It's not exactly necessary on master, because there are more or less
intuitive default widths, but these are sometimes inefficient (and
note that I made this feature so I want to have it :P)."
  ((dynamic-attribute-width-p t)))

(defmethod files:resolve ((profile nyxt:nyxt-profile) (file nyxt/mode/bookmark:bookmarks-file))
  "Reroute the bookmarks to the config directory."
  #p"~/.config/nyxt/bookmarks.lisp")

(define-configuration :reduce-tracking-mode
  ((query-tracking-parameters
    (append '("utm_source" "utm_medium" "utm_campaign" "utm_term" "utm_content")
            %slot-value%)
    :doc "This is to strip UTM-parameters off all the links.
Upstream Nyxt doesn't have it because it may break some websites.")
   (preferred-user-agent
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36"
    :doc "Mimic Chrome on MacOS.")))


(define-command-global start-slynk (&optional (slynk-port *swank-port*))
  "Start a Slynk server that can be connected to, for instance, in
Emacs via SLY.

Warning: This allows Nyxt to be controlled remotely, that is, to execute
arbitrary code with the privileges of the user running Nyxt.  Make sure
you understand the security risks associated with this before running
this command."
  (slynk:create-server :port slynk-port :dont-close t :interface "0.0.0.0")
  (echo "Slynk server started at port ~a" slynk-port))
;; (start-slynk)
