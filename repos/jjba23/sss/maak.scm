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

(define-module (maak)
  #:declarative? #t
  #:use-module (maak maak))

;; ====== Maak constants ======

;; The absolute path to the directory where the main project files will be deployed.
(define deploy-dir
  "/srv/http/jointhefreeworld.org")

;; The main copyright holders of the project.
(define copyright-holders
  '("Josep Bigorra"))

;; The path to the directory where the i18n resources are located.
(define i18n-dir
  "./resources/locale")

;; The text domain for the i18n translations.
(define i18n-textdomain
  "sss")

(define i18n-locales
  '(en_US nl_NL))

;; The Emacs Lisp script to run for publishing the manual. 
(define emacs-lisp-manual-publish-cmd
  '(progn (find-file "./docs/manual/en.org")
          (org-html-export-to-html)
          (message "finished publishing SSS manual")))

;; The Emacs Lisp script to run for indenting ELisp files.
(define emacs-lisp-indent-cmd
  '(progn (indent-region (point-min)
                         (point-max) nil)
          (untabify (point-min)
                    (point-max))
          (delete-trailing-whitespace)
          (save-buffer)))

(define hot-reload-file-types
  '(scm el lisp))

;; ====== Maak prelude ======

;; Specify the directory where the MO file is located
(bindtextdomain i18n-textdomain i18n-dir)
(bind-textdomain-codeset i18n-textdomain "UTF-8")
;; Specify the domain of the MO file
(textdomain i18n-textdomain)
(define G_
  gettext)

;; ====== Maak abstractions ======

(define (log-done)
  (log-info (G_ "Task was completed successfully!")))

(define (run-system-script file)
  ($ (list "guile -L ./per-host -L ./src"
           (~ "system/scripts/~a.scm" file))))

(define (run-installed-script file)
  ($ (list (~ "sh ~~/.local/bin/~a.sh" file))))

(define (notify title message)
  ($ (list (~ "fyi \"~a\" \"~a\" >/dev/null 2>&1" title message))))

(define (user-reconfigure user)
  (fmt)
  (test)
  ($ (list "guix home reconfigure " "-L ./per-host -L ./src"
           (~ "./home/~a.scm" user) "--fallback"))
  ($ '("fc-cache -frv >/dev/null 2>&1 &"))
  (run-installed-script 'write-gtk-dconf-settings)
  (run-installed-script 'write-sss-dconf-settings)
  ($ '("herd trigger set-random-wallpaper"))
  (document-keybindings-dconf)
  (log-done)
  (notify (G_ "SSS user-reconfigure")
          (G_ "Task was completed successfully!")))

;; ====== Maak i18n abstractions ======

(define (i18n-compile* lang)
  "Compile the translation file (.po) into a machine-readable (.mo) format

Args: lang represents the language code (e.g., en_US, nl_NL, etc.)

Use msgfmt to compile the .po file into a .mo file for the specified language
The output .mo file will be placed in the LC_MESSAGES directory under the language's folder."
  ($ (list (~ "msgfmt -v -o ~a/~a/LC_MESSAGES/~a.mo" i18n-dir lang
              i18n-textdomain)
           (~ "~a/~a/LC_MESSAGES/~a.po" i18n-dir lang i18n-textdomain))))

(define (i18n-init* lang)
  "Initialize a new translation file from a template (.pot) for a specific language.

Args: lang represents the language code (e.g., en_US, nl_NL, etc.)

Use msginit to generate a .po file from the .pot template for the specified language
The -l option sets the language, and --no-translator means no translator is pre-filled in the .po file
The generated .po file is placed in the LC_MESSAGES directory for the given language"
  (mkdir-p (~ "~a/~a/LC_MESSAGES" i18n-dir lang))
  ($ (list (~ "msginit -l ~a.UTF8 -o" lang)
           (~ "~a/~a/LC_MESSAGES/~a.po" i18n-dir lang i18n-textdomain)
           (~ "-i ~a/~a.pot --no-translator" i18n-dir i18n-textdomain))
     #:verbose? #t))

(define (i18n-merge* lang)
  "Merge translation updates from the template (.pot) into an existing .po file.

Args: lang represents the language code (e.g., en_US, nl_NL, etc.)

Use msgmerge to update the specified language's .po file with new translations from the template (.pot)
The -U flag updates the .po file in place
This ensures the .po file stays up-to-date with the latest changes in the template"
  ($ (list "msgmerge -U"
           (~ "~a/~a/LC_MESSAGES/~a.po" i18n-dir lang i18n-textdomain)
           (~ "~a/~a.pot" i18n-dir i18n-textdomain))))

(define* (i18n-extract* #:key (update? #t))
  "Extract translatable strings from Scheme source files using xgettext.
Args: update? represents whether we should update a template or create a new one."
  ($ (list (~ "xgettext --default-domain=~a" i18n-textdomain)
           (~ "--output=~a/~a.pot" i18n-dir i18n-textdomain)
           "--language=Scheme --keyword=G_"
           "--sort-by-file"
           (if update? "--join-existing" "")
           (~ "--copyright-holder=\"~a\""
              (string-join copyright-holders ","))
           (~ "--package-name=~a" i18n-textdomain)
           "system/scripts/*.scm"
           "system/*.scm"
           "src/sss/*.scm"
           "src/sss/hyprland/*.scm"
           "system/packages/sss-packages/*.scm"
           "home/*.scm"
           "--from-code UTF-8")
     #:verbose? #t))

;; ====== Maak tasks ======

(define (update-submodules)
  "Update all the SSS submodules."
  ($ '("git submodule update --recursive --remote")))

(define (update)
  "Update the system and channels."
  ($ '("git pull"))
  (update-submodules)
  ($ '("guix pull")))

(define (fmt)
  "Format project source code files."
  ($ '("find . -maxdepth 8 -name '*.scm'" "-type f -exec guix style -f {} \\;")
     #:verbose? #t)
  ($ (list "find ~+ -maxdepth 8 -name '*.el'"
           "-type f -exec emacs -Q --batch {} "
           (~ "--eval '~s'" emacs-lisp-indent-cmd) "\\;")
     #:verbose? #t)
  ($ (list "mbake format --config .mbake.toml Makefile")
     #:verbose? #t))

(define (repl)
  "Development REPL."
  (manifest-shell '("guile -L ./src -L ./per-host -L ./system/packages/"
                    "-c '((@ (ares server) run-nrepl-server))'")))

(define (test)
  "Unit tests."
  (manifest-shell '("guile -L ./src -L ./per-host -L ./test"
                    "-c '((@ (veritas runner) run-tests))'")))

(define (nix-packages-install)
  "Install Nix packages for SSS."
  (run-system-script 'install-nix-packages))

(define (nix-packages-update)
  "Update all Nix packages for SSS."
  (run-system-script 'update-nix-packages))

(define (flatpak-packages-install)
  "Install Flatpak packages for SSS."
  (run-system-script 'install-flatpak-packages))

(define (flatpak-packages-update)
  "Update all Flatpak packages for SSS."
  ($ '("flatpak update --user -y")))

(define (default)
  "Default task to be run, list available tasks."
  ($ '("maak --list")))

(define (document-keybindings-dconf)
  "Write SSS keybinding documentation to dconf."
  (run-system-script 'document-keybindings-dconf))

(define (joe-reconfigure)
  "Re-configure Joe's Guix Home."
  (user-reconfigure 'joe)
  ($ '("hyprctl reload || true")))

(define (manon-reconfigure)
  "Re-configure Manon's Guix Home."
  (user-reconfigure 'manon))

(define (system-reconfigure)
  "Re-configure the Guix system."
  (fmt)
  (test)
  ($ '("sudo guix system reconfigure"
       "-L ./per-host -L ./system/packages -L ./src" "./system/config.scm"
       "--fallback --on-error=backtrace"))
  ($ '("sudo fc-cache -frv >/dev/null 2>&1 &"))
  (log-done)
  (notify (G_ "SSS system-reconfigure")
          (G_ "Task was completed successfully!")))

(define (store-gc)
  "Clean up unused objects in the Guix store."
  ($ '("sudo guix gc")))

(define (clone-user-repos)
  "Clones user's desired Git repositories."
  (run-system-script 'clone-user-repos))

(define (build-manual)
  "Render the project's manual."
  (manifest-shell (list (~ "emacs -Q --batch --eval '~s'"
                           emacs-lisp-manual-publish-cmd))
                  #:verbose? #t))

(define (deploy)
  "Deploy the project's documentation."
  (build-manual)
  (mkdir-p (~ "~a/manuals/sss" deploy-dir))
  (delete-file-recursively (~ "~a/manuals/sss/index.html" deploy-dir))
  (mv "docs/manual/en.html"
      (~ "~a/manuals/sss/index.html" deploy-dir)))

(define (hot-reload)
  "Hot-reloading developer's setup."
  (manifest-shell (list "watchexec 'maak test'"
                        "--clear"
                        (~ "--exts ~a"
                           (string-join (map symbol->string
                                             hot-reload-file-types) ","))
                        "--on-busy-update=restart"
                        "--shell bash"
                        "--watch .")))

;; ====== Maak i18n tasks ======

(define (i18n-compile)
  "Compile the translation files for all locales."
  (for-each i18n-compile* i18n-locales))

(define (i18n-init-en)
  "Initialize a new translation file for en_US."
  (i18n-init* 'en_US))

(define (i18n-init-nl)
  "Initialize a new translation file for nl_NL."
  (i18n-init* 'nl_NL))

(define (i18n-merge)
  "Merge translation updates for all locales."
  (for-each i18n-merge* i18n-locales))

(define (i18n-new-template)
  "Create a new i18n template based on strings extracted from source code."
  (i18n-extract* #:update? #f))

(define (i18n-update-template)
  "Update the i18n template based on strings extracted from source code."
  (i18n-extract* #:update? #t))

;; ====== Maak aliases ======

(define (npi)
  "Alias to nix-packages-install."
  (nix-packages-install))

(define (npu)
  "Alias to nix-packages-update."
  (nix-packages-update))

(define (fpi)
  "Alias to flatpak-packages-install."
  (flatpak-packages-install))

(define (fpu)
  "Alias to flatpak-packages-update."
  (flatpak-packages-update))

(define (sr)
  "Alias to system-reconfigure."
  (system-reconfigure))

(define (jr)
  "Alias to joe-reconfigure."
  (joe-reconfigure))

(define (mr)
  "Alias to manon-reconfigure."
  (manon-reconfigure))

(define (hr)
  "Alias to hot-reloading."
  (hot-reload))

(define (dev)
  "Developer's setup."
  (hot-reload))

