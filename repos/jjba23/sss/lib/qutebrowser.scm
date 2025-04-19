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

(load "./palette.scm")
(load "./process.scm")

(define-module (sss qutebrowser)
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss process))

(begin
  (define* (sss-qutebrowser-palette #:key palette)
    `((bg-default unquote
                  (sss-get-color palette
                                 'background))
      (bg-lighter unquote
                  (sss-get-color palette
                                 'background-l))
      (bg-selection . "#3e4451")
      (fg-disabled unquote
                   (sss-get-color palette
                                  'text))
      (fg-default unquote
                  (sss-get-color palette
                                 'text))
      (bg-lightest . "#c8ccd4")
      (fg-error . "#e06c75")
      (bg-hint . "#e5c07b")
      (fg-matched-text . "#98c379")
      (bg-passthrough-mode . "#56b6c2")
      (bg-insert-mode unquote
                      (sss-get-color palette
                                     'primary))
      (bg-warning . "#d19a66")))
  (export sss-qutebrowser-palette))

(define sss-qutebrowser-theme
  `( ;Text color of the completion widget. May be a single color to use for
    

    ;; all columns or a list of three colors, one for each column.
    (completion.fg fg-default)
    ;; Background color of the completion widget for odd rows.
    (completion.odd.bg bg-lighter)
    ;; Background color of the completion widget for even rows.
    (completion.even.bg bg-default)
    ;; Foreground color of completion widget category headers.
    (completion.category.fg bg-hint)
    ;; Background color of the completion widget category headers.
    (completion.category.bg bg-default)
    ;; Top border color of the completion widget category headers.
    (completion.category.border.top bg-default)
    ;; Bottom border color of the completion widget category headers.
    (completion.category.border.bottom bg-default)
    ;; Foreground color of the selected completion item.
    (completion.item.selected.fg fg-default)
    ;; Background color of the selected completion item.
    (completion.item.selected.bg bg-selection)
    ;; Top border color of the selected completion item.
    (completion.item.selected.border.top bg-selection)
    ;; Bottom border color of the selected completion item.
    (completion.item.selected.border.bottom bg-selection)
    ;; Foreground color of the matched text in the selected completion item.
    (completion.item.selected.match.fg fg-matched-text)
    ;; Foreground color of the matched text in the completion.
    (completion.match.fg fg-matched-text)
    ;; Color of the scrollbar handle in the completion view.
    (completion.scrollbar.fg fg-default)
    ;; Color of the scrollbar in the completion view.
    (completion.scrollbar.bg bg-default)
    ;; Background color of disabled items in the context menu.
    (contextmenu.disabled.bg bg-lighter)
    ;; Foreground color of disabled items in the context menu.
    (contextmenu.disabled.fg fg-disabled)
    ;; Background color of the context menu. If set to null, the Qt default is used.
    (contextmenu.menu.bg bg-default)
    ;; Foreground color of the context menu. If set to null, the Qt default is used.
    (contextmenu.menu.fg fg-default)
    ;; Background color of the context menu’s selected item. If set to null, the Qt default is used.
    (contextmenu.selected.bg bg-selection)
    ;; Foreground color of the context menu’s selected item. If set to null, the Qt default is used.
    (contextmenu.selected.fg fg-default)
    ;; Background color for the download bar.
    (downloads.bar.bg bg-default)
    ;; Color gradient start for download text.
    (downloads.start.fg bg-default)
    ;; Color gradient start for download backgrounds.
    (downloads.start.bg bg-insert-mode)
    ;; Color gradient end for download text.
    (downloads.stop.fg bg-default)
    ;; Color gradient stop for download backgrounds.
    (downloads.stop.bg bg-passthrough-mode)
    ;; Foreground color for downloads with errors.
    (downloads.error.fg fg-error)
    ;; Font color for hints.
    (hints.fg bg-default)
    ;; Background color for hints. Note that you can use a `rgba(...)` value
    ;; for transparency.
    (hints.bg bg-hint)
    ;; Font color for the matched part of hints.
    (hints.match.fg fg-default)
    ;; Text color for the keyhint widget.
    (keyhint.fg fg-default)
    ;; Highlight color for keys to complete the current keychain.
    (keyhint.suffix.fg fg-default)
    ;; Background color of the keyhint widget.
    (keyhint.bg bg-default)
    ;; Foreground color of an error message.
    (messages.error.fg bg-default)
    ;; Background color of an error message.
    (messages.error.bg fg-error)
    ;; Border color of an error message.
    (messages.error.border fg-error)
    ;; Foreground color of a warning message.
    (messages.warning.fg bg-default)
    ;; Background color of a warning message.
    (messages.warning.bg bg-warning)
    ;; Border color of a warning message.
    (messages.warning.border bg-warning)
    ;; Foreground color of an info message.
    (messages.info.fg fg-default)
    ;; Background color of an info message.
    (messages.info.bg bg-default)
    ;; Border color of an info message.
    (messages.info.border bg-default)
    ;; Foreground color for prompts.
    (prompts.fg fg-default)
    ;; Border used around UI elements in prompts.
    (prompts.border bg-default)
    ;; Background color for prompts.
    (prompts.bg bg-default)
    ;; Background color for the selected item in filename prompts.
    (prompts.selected.bg bg-selection)
    ;; Foreground color for the selected item in filename prompts.
    (prompts.selected.fg fg-default)
    ;; Foreground color of the statusbar.
    (statusbar.normal.fg fg-matched-text)
    ;; Background color of the statusbar.
    (statusbar.normal.bg bg-default)
    ;; Foreground color of the statusbar in insert mode.
    (statusbar.insert.fg bg-default)
    ;; Background color of the statusbar in insert mode.
    (statusbar.insert.bg bg-insert-mode)
    ;; Foreground color of the statusbar in passthrough mode.
    (statusbar.passthrough.fg bg-default)
    ;; Background color of the statusbar in passthrough mode.
    (statusbar.passthrough.bg bg-passthrough-mode)
    ;; Foreground color of the statusbar in private browsing mode.
    (statusbar.private.fg bg-default)
    ;; Background color of the statusbar in private browsing mode.
    (statusbar.private.bg bg-lighter)
    ;; Foreground color of the statusbar in command mode.
    (statusbar.command.fg fg-default)
    ;; Background color of the statusbar in command mode.
    (statusbar.command.bg bg-default)
    ;; Foreground color of the statusbar in private browsing + command mode.
    (statusbar.command.private.fg fg-default)
    ;; Background color of the statusbar in private browsing + command mode.
    (statusbar.command.private.bg bg-default)
    ;; Foreground color of the statusbar in caret mode.
    (statusbar.caret.fg bg-default)
    ;; Background color of the statusbar in caret mode.
    (statusbar.caret.bg bg-warning)
    ;; Foreground color of the statusbar in caret mode with a selection.
    (statusbar.caret.selection.fg bg-default)
    ;; Background color of the statusbar in caret mode with a selection.
    (statusbar.caret.selection.bg bg-insert-mode)
    ;; Background color of the progress bar.
    (statusbar.progress.bg bg-insert-mode)
    ;; Default foreground color of the URL in the statusbar.
    (statusbar.url.fg fg-default)
    ;; Foreground color of the URL in the statusbar on error.
    (statusbar.url.error.fg fg-error)
    ;; Foreground color of the URL in the statusbar for hovered links.
    (statusbar.url.hover.fg fg-default)
    ;; Foreground color of the URL in the statusbar on successful load
    ;; (http).
    (statusbar.url.success.http.fg bg-passthrough-mode)
    ;; Foreground color of the URL in the statusbar on successful load
    ;; (https).
    (statusbar.url.success.https.fg fg-matched-text)
    ;; Foreground color of the URL in the statusbar when there's a warning.
    (statusbar.url.warn.fg bg-warning)
    ;; Background color of the tab bar.
    (tabs.bar.bg bg-default)
    ;; Color gradient start for the tab indicator.
    (tabs.indicator.start bg-insert-mode)
    ;; Color gradient end for the tab indicator.
    (tabs.indicator.stop bg-passthrough-mode)
    ;; Color for the tab indicator on errors.
    (tabs.indicator.error fg-error)
    ;; Foreground color of unselected odd tabs.
    (tabs.odd.fg fg-default)
    ;; Background color of unselected odd tabs.
    (tabs.odd.bg bg-lighter)
    ;; Foreground color of unselected even tabs.
    (tabs.even.fg fg-default)
    ;; Background color of unselected even tabs.
    (tabs.even.bg bg-default)
    ;; Background color of pinned unselected even tabs.
    (tabs.pinned.even.bg bg-passthrough-mode)
    ;; Foreground color of pinned unselected even tabs.
    (tabs.pinned.even.fg bg-lightest)
    ;; Background color of pinned unselected odd tabs.
    (tabs.pinned.odd.bg fg-matched-text)
    ;; Foreground color of pinned unselected odd tabs.
    (tabs.pinned.odd.fg bg-lightest)
    ;; Background color of pinned selected even tabs.
    (tabs.pinned.selected.even.bg bg-selection)
    ;; Foreground color of pinned selected even tabs.
    (tabs.pinned.selected.even.fg fg-default)
    ;; Background color of pinned selected odd tabs.
    (tabs.pinned.selected.odd.bg bg-selection)
    ;; Foreground color of pinned selected odd tabs.
    (tabs.pinned.selected.odd.fg fg-default)
    ;; Foreground color of selected odd tabs.
    (tabs.selected.odd.fg fg-default)
    ;; Background color of selected odd tabs.
    (tabs.selected.odd.bg bg-selection)
    ;; Foreground color of selected even tabs.
    (tabs.selected.even.fg fg-default)
    ;; Background color of selected even tabs.
    (tabs.selected.even.bg bg-selection)
    ;; Background color for webpages if unset (or empty to use the theme's
    ;; color).
    ;; webpage.bg  bg-default
    ))

(define sss-qutebrowser-command-bindings
  `(("<ctrl-s>" . "search-next") ("<ctrl-r>" . "search-prev")
    ("<ctrl-p>" . "completion-item-focus prev")
    ("<ctrl-n>" . "completion-item-focus next")
    ("<alt-p>" . "command-history-prev")
    ("<alt-n>" . "command-history-next")
    ("<ctrl-g>" . "mode-leave")
    ("<ctrl-c><ctrl-r>" . "undo --window")
    ("<ctrl-shift+_>" . "undo")))

(define sss-qutebrowser-hint-bindings
  `(("<ctrl-g>" . "mode-leave")))

(define sss-qutebrowser-insert-bindings
  `(("<ctrl-f>" . "fake-key <Right>") ("<ctrl-b>" . "fake-key <Left>")
    ("<ctrl-a>" . "fake-key <Home>")
    ("<ctrl-e>" . "fake-key <End>")
    ("<ctrl-n>" . "fake-key <Down>")
    ("<ctrl-p>" . "fake-key <Up>")
    ("<alt-f>" . "fake-key <Ctrl-Right>")
    ("<alt-b>" . "fake-key <Ctrl-Left>")
    ("<ctrl-d>" . "fake-key <Delete>")
    ("<alt-d>" . "fake-key <Ctrl-Delete>")
    ("<alt-backspace>" . "fake-key <Ctrl-Backspace>")
    ("<ctrl-w>" . "fake-key <Ctrl-backspace>")
    ("<ctrl-y>" . "insert-text {primary}")
    ("<ctrl-g>" . "mode-leave")
    ("<alt-x>" . "cmd-set-text :")
    ("<ctrl-x><g>" . "reload")
    ("<f5>" . "reload")
    ("<f12>" . "devtools")
    ("<ctrl-c><i>" . "devtools")
    ("<alt-w>" . "yank selection")
    ("<ctrl-x><Right>" . "forward")
    ("<ctrl-x><Left>" . "back")
    ("<ctrl-=>" . "zoom-in")
    ("<ctrl-x>=" . "zoom-in")
    ("<ctrl-x><ctrl-=>" . "zoom-in")
    ("<ctrl-->" . "zoom-out")
    ("<ctrl-x>-" . "zoom-out")
    ("<ctrl-x><ctrl-->" . "zoom-out")))

(define sss-qutebrowser-caret-bindings
  `(("<ctrl-g>" . "mode-leave")))

(define sss-qutebrowser-normal-bindings
  `( ;Navigation
     ("<ctrl-v>" . "scroll-page 0 0.9")
    ("<alt-v>" . "scroll-page 0 -0.9")
    ("<Backspace>" . "scroll-page 0 -0.9")
    ;; '<Space>' . 'scroll-page 0 0.9'
    ("<alt-shift-." . "scroll-to-perc")
    ("<alt-shift-.>" . "scroll-to-perc 0")
    ("<ctrl-=>" . "zoom-in")
    ("<ctrl-x>=" . "zoom-in")
    ("<ctrl-x><ctrl-=>" . "zoom-in")
    ("<ctrl-->" . "zoom-out")
    ("<ctrl-x>-" . "zoom-out")
    ("<ctrl-x><ctrl-->" . "zoom-out")
    ;; Commands
    ("<alt-x>" . "cmd-set-text :")
    ("<ctrl-x><ctrl-c>" . "quit")
    ;; searching
    ("<ctrl-s>" . "cmd-set-text /")
    ("<ctrl-r>" . "cmd-set-text ?")
    ;; hinting
    ("<f>" . "hint all")
    ("<ctrl-u><f>" . "hint all hover")
    ("<shift-f>" . "hint all tab-bg")
    ("<ctrl-u><shift-e>" . "hint all tab-fg")
    ("<w><l>" . "hint all yank-primary")
    ("<w><w>" . "yank url")
    ("<d>" . "yank all download")
    ;; history
    ("<ctrl-x><Right>" . "forward")
    ("<ctrl-x><Left>" . "back")
    ("shift-h>" . "history")
    ;; bookmarks
    ("m" . "bookmark-add")
    ("M" . "open qute://bookmarks")
    ;; tabs
    ("<ctrl-x><t><c>" . "tab-clone")
    ("<ctrl-x><t><k>" . "tab-close")
    ("<ctrl-x><t><n>" . "open -t https://jointhefreeworld.org/joe-web-welkomscherm/")
    ("<ctrl-tab>" . "tab-next")
    ("<ctrl-shift-tab>" . "tab-prev")
    ("<alt-n>" . "tab-next")
    ("<shift-alt-n>" . "tab-move +")
    ("<alt-p>" . "tab-prev")
    ("<shift-alt-p>" . "tab-move -")
    ("<ctrl-x><b>" . "cmd-set-text -s :buffer")
    ("<ctrl-x><k>" . "tab-close")
    ("<ctrl-c><p>" . "tab-pin")
    ("<ctrl-c><m>" . "tab-mute")
    ("<ctrl-x><0>" . "tab-close")
    ("<ctrl-x><1>" . "tab-only")
    ("<Alt-1>" . "tab-focus 1")
    ("<Alt-2>" . "tab-focus 2")
    ("<Alt-3>" . "tab-focus 3")
    ("<Alt-4>" . "tab-focus 4")
    ("<Alt-5>" . "tab-focus 5")
    ("<Alt-6>" . "tab-focus 6")
    ("<Alt-7>" . "tab-focus 7")
    ("<Alt-8>" . "tab-focus 8")
    ("<Alt-9>" . "tab-focus -1")
    ;; frames
    ("<ctrl-x><5><0>" . "close")
    ("<ctrl-x><5><1>" . "window-only")
    ("<ctrl-x><5><2>" . "cmd-set-text -s  :open -w")
    ("<ctrl-u><ctrl-x><5><2>" . "cmd-set-text -s :open -p")
    ;; open links
    ("<g>" . "cmd-set-text -s :open")
    ("<shift-g>" . "cmd-set-text -s :open -t")
    ;; editing
    ("<ctrl-f>" . "fake-key <Right>")
    ("<ctrl-b>" . "fake-key <Left>")
    ("<ctrl-a>" . "fake-key <Home>")
    ("<ctrl-e>" . "fake-key <End>")
    ("<ctrl-n>" . "fake-key <Down>")
    ("<ctrl-p>" . "fake-key <Up>")
    ("<alt-f>" . "fake-key <Ctrl-Right>")
    ("<alt-b>" . "fake-key <Ctrl-Left>")
    ("<ctrl-d>" . "fake-key <Delete>")
    ("<alt-d>" . "fake-key <Ctrl-Delete>")
    ("<alt-backspace>" . "fake-key <Ctrl-Backspace>")
    ("<ctrl-w>" . "fake-key <Ctrl-backspace>")
    ("<ctrl-y>" . "insert-text {primary}")
    ;; Numbers
    ;; https://github.com/qutebrowser/qutebrowser/issues/4213
    ("1" . "fake-key 1")
    ("2" . "fake-key 2")
    ("3" . "fake-key 3")
    ("4" . "fake-key 4")
    ("5" . "fake-key 5")
    ("6" . "fake-key 6")
    ("7" . "fake-key 7")
    ("8" . "fake-key 8")
    ("9" . "fake-key 9")
    ("0" . "fake-key 0")
    ;; misc
    ("<ctrl-c><v>" . "spawn --userscript ~/.bin/open_in_mpv.sh")
    ;; Help
    ("<ctrl-h><b>" . "open qute://bindings")
    ("<ctrl-h><h>" . "cmd-set-text -s :help")
    ;; escape hatch
    ("<ctrl-g>" . "ESC_BIND")
    ;;
    ("<ctrl-x><g>" . "reload")
    ("<f5>" . "reload")
    ("<f12>" . "devtools")
    ("<ctrl-c><i>" . "devtools")
    ("<alt-w>" . "yank selection")))

(define-public sss-qutebrowser-bookmarks
  `(("Jointhefreeworld" . "https://jointhefreeworld.org/")
    ("BoxIcons" . "https://github.com/atisawd/boxicons")
    ("Byggsteg" . "https://byggsteg.jointhefreeworld.org/")
    ("Guix Packages" . "https://packages.guix.gnu.org")
    ("Reddit" . "https://reddit.com")
    ("GNU G-Golf reference" . "https://www.gnu.org/software/g-golf/manual/g-golf.html")
    ("Slack Vandebron" . "https://app.slack.com/client/T1XNW2SF5/C081CULEKV3")
    ("Coding Standards Vandebron" . "https://vandebron.atlassian.net/wiki/spaces/DIG/pages/edit-v2/95582126047266")))

(define-public (serialize-qutebrowser-urls alist)
  (string-join (map (lambda (e)
                      (format #f "~a - ~a"
                              (cdr e)
                              (car e))) alist) "\n"))

(define* (sss-qutebrowser-apply-color #:key palette k color)
  (format #f "c.colors.~a = ~s\n" k
          (assq-ref (sss-qutebrowser-palette #:palette palette) color)))

(define (serialize-qutebrowser-bindings alist)
  (map (lambda (e)
         (format #f "'~a': '~a',\n"
                 (car e)
                 (cdr e))) alist))

(define (sss-qutebrowser-commands-bindings key alist)
  (format #f "c.bindings.commands['~a'] = {\n~a\n}" key
          (string-join (serialize-qutebrowser-bindings alist) "")))

(define (sss-qutebrowser-set-config-opt opt val)
  (format #f "config.set('~a', ~a)" opt val))

(begin
  (define* (sss-qutebrowser-config #:key palette)
    (string-join (append `("config = config" "c = c"
                           "config.load_autoconfig(False)"
                           ,(sss-qutebrowser-set-config-opt
                             "completion.use_best_match"
                             'True)
                           ,(sss-qutebrowser-set-config-opt
                             "auto_save.interval" 0)
                           ;; ,(sss-qutebrowser-set-config-opt "colors.webpage.darkmode.enabled" 'True)
                           "c.input.insert_mode.plugins = True"
                           "c.input.insert_mode.auto_load = True"
                           "c.input.forward_unbound_keys = 'all'"
                           "c.url.start_pages = ['https://jointhefreeworld.org/joe-web-welkomscherm/']"
                           "config.set('content.notifications.enabled', True, '*://app.slack.com/')"
                           "ESC_BIND = 'clear-keychain ;; search ;; fullscreen --leave'"
                           "c.bindings.default['normal'] = {}")
                         `(,(sss-qutebrowser-commands-bindings 'command
                             sss-qutebrowser-command-bindings) ,(sss-qutebrowser-commands-bindings 'normal
                                                                 sss-qutebrowser-normal-bindings)
                           ,(sss-qutebrowser-commands-bindings 'insert
                             sss-qutebrowser-insert-bindings)
                           ,(sss-qutebrowser-commands-bindings 'caret
                             sss-qutebrowser-caret-bindings)
                           ,(sss-qutebrowser-commands-bindings 'hint
                             sss-qutebrowser-hint-bindings))
                         (map (lambda (e)
                                (sss-qutebrowser-apply-color #:palette palette
                                                             #:k (car e)
                                                             #:color (car (cdr
                                                                           e))))
                              sss-qutebrowser-theme)) "\n"))

  (export sss-qutebrowser-config))

(begin
  (define* (sss-qutebrowser-svc #:key palette
                                (bookmarks sss-qutebrowser-bookmarks))
    `((".config/qutebrowser/config.py" ,(plain-file "config.py"
                                                    (sss-qutebrowser-config
                                                     #:palette palette)))
      (".config/qutebrowser/bookmarks/urls" ,(plain-file "urls"
                                                         (serialize-qutebrowser-urls
                                                          bookmarks)))))
  (export sss-qutebrowser-svc))
