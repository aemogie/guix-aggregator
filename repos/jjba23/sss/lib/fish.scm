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

(define-module (sss fish)
  #:use-module (gnu))

(define (serialize-fish-abbreviation a)
  (format #f "abbr -a ~a \"~a\""
          (car a)
          (cdr a)))

(define* (sss-fish-abbreviations #:key clone-dir)
  `((c . "clear") (h . "history")
    (tree . "tree --dirsfirst -F")
    (mkdir . "mkdir -p -v")
    (ll . "ls -lAh --group-directories-first")
    (l . "ls -lAh --group-directories-first")
    (e . "emacsclient -t")
    (k . "pkill")
    (fetch . "fastfetch")
    (vanilla-emacs . "emacs -Q")
    (restart-emacs . "pkill emacs && emacs --daemon")
    (fr unquote
        (format #f "cd ~a && make fr" clone-dir))
    (sr unquote
        (format #f "cd ~a && make sr" clone-dir))
    (jr unquote
        (format #f "cd ~a && make jr" clone-dir))
    (pm unquote
        (format #f "cd ~a && make publish-manual" clone-dir))
    (npi unquote
         (format #f "cd ~a && make npi" clone-dir))
    (npu unquote
         (format #f "cd ~a && make npu" clone-dir))
    (fpi unquote
         (format #f "cd ~a && make fpi" clone-dir))
    (fpu unquote
         (format #f "cd ~a && make fpu" clone-dir))
    (scala-dev unquote
               (format #f "nix develop ~a/resources/flakes/scala-dev/"
                       clone-dir))
    (haskell-dev unquote
                 (format #f "nix develop ~a/resources/flakes/haskell-dev/"
                         clone-dir))
    (docker . "podman")
    (docker-compose . "podman-compose")
    (podman-unix-socket . "podman system service --time=0 unix:///tmp/podman.sock")
    (gui . "hyprland")
    (find-largest-files . "du -h -x -s -- * | sort -r -h | head -20")))

(define (fish-color-for-palette palette)
  (cond
    ((eq? 'sss-palette-ef-dream palette)
     'magenta)
    ((eq? 'sss-palette-ef-bio palette)
     'green)
    ((eq? 'sss-palette-heavy-metal palette)
     'red)
    ((eq? 'sss-palette-ef-cyprus palette)
     'green)
    ((eq? 'sss-palette-ef-autumn palette)
     'yellow)
    ((eq? 'sss-palette-solarized-light palette)
     'yellow)
    ((eq? 'sss-palette-everforest-dark palette)
     'green)
    ((eq? 'sss-palette-everforest-light palette)
     'green)
    (else 'magenta)))

(define* (shell-greeting #:key palette)
  `(,(format #f "set_color -o ~a"
             (fish-color-for-palette palette))
    "echo \"Welcome to SSS/GNU - the Supreme Sexp System\"" "echo \"\""
    "set_color normal"))

(define* (serialize-fish-greeting #:key palette)
  (format #f "function fish_greeting\n    ~a\nend"
          (string-join (shell-greeting #:palette palette) "\n    ")))

(define* (shell-prompt #:key palette)
  `("set -l last_status $status"

    ,(format #f "set_color -o ~a"
             (fish-color-for-palette palette))
    "echo -n \"$USER@\"(hostname)"
    "set_color normal"

    "echo -n ': '"

    ;; PWD
    "set_color $fish_color_cwd"
    "echo -n (prompt_pwd)"
    "set_color normal"

    "set -q __fish_git_prompt_showdirtystate"
    "or set -g __fish_git_prompt_showdirtystate 1"
    "set -q __fish_git_prompt_showuntrackedfiles"
    "or set -g __fish_git_prompt_showuntrackedfiles 1"
    "set -q __fish_git_prompt_showcolorhints"
    "or set -g __fish_git_prompt_showcolorhints 1"
    "set -q __fish_git_prompt_color_untrackedfiles"
    "or set -g __fish_git_prompt_color_untrackedfiles yellow"
    "set -q __fish_git_prompt_char_untrackedfiles"
    "or set -g __fish_git_prompt_char_untrackedfiles '?'"
    "set -q __fish_git_prompt_color_invalidstate"
    "or set -g __fish_git_prompt_color_invalidstate red"
    "set -q __fish_git_prompt_char_invalidstate"
    "or set -g __fish_git_prompt_char_invalidstate '!'"
    "set -q __fish_git_prompt_color_dirtystate"
    "or set -g __fish_git_prompt_color_dirtystate blue"
    "set -q __fish_git_prompt_char_dirtystate"
    "or set -g __fish_git_prompt_char_dirtystate '*'"
    "set -q __fish_git_prompt_char_stagedstate"
    "or set -g __fish_git_prompt_char_stagedstate '✚'"
    "set -q __fish_git_prompt_color_cleanstate"
    "or set -g __fish_git_prompt_color_cleanstate green"
    "set -q __fish_git_prompt_char_cleanstate"
    "or set -g __fish_git_prompt_char_cleanstate '✓'"
    "set -q __fish_git_prompt_color_stagedstate"
    "or set -g __fish_git_prompt_color_stagedstate yellow"
    "set -q __fish_git_prompt_color_branch_dirty"
    "or set -g __fish_git_prompt_color_branch_dirty red"
    "set -q __fish_git_prompt_color_branch_staged"
    "or set -g __fish_git_prompt_color_branch_staged yellow"
    "set -q __fish_git_prompt_color_branch"
    "or set -g __fish_git_prompt_color_branch green"
    "set -q __fish_git_prompt_char_stateseparator"
    "or set -g __fish_git_prompt_char_stateseparator ' '"
    "fish_vcs_prompt ': %s'"
    "echo"

    ;; 2nd line of prompt
    "if not test $last_status -eq 0"
    "set_color $fish_color_error"
    "end"

    "echo -n 'λ '"
    "set_color normal"))

(define* (serialize-fish-prompt prompt)
  (format #f "function fish_prompt\n    ~a\nend"
          (string-join prompt "\n    ")))

(begin
  (define* (sss-fish-config #:key clone-dir palette)
    (append `("#
# SSS - Supreme Sexp System - fish configurations
#
# auto-generated file! do not edit!
#
"
              ;; turn on the Emacs-style keybindings for the shell
              "fish_default_key_bindings" "")
            ;; abbreviations (a much better approach than aliases)
            (map serialize-fish-abbreviation
                 (sss-fish-abbreviations #:clone-dir clone-dir))
            `("")
            (list (serialize-fish-greeting #:palette palette))
            `("")
            (list (serialize-fish-prompt (shell-prompt #:palette palette)))))
  (export sss-fish-config))

(begin
  (define* (sss-fish-svc #:key clone-dir palette)
    `((".config/fish/config.fish" ,(plain-file "config.fish"
                                               (string-join (sss-fish-config
                                                             #:clone-dir
                                                             clone-dir
                                                             #:palette palette)
                                                            "\n")))))
  (export sss-fish-svc))

