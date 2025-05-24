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

(define-module (sss bash)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (gnu home services shells))

(define sss-bash-vars
  `((green . "'\\[\\033[01;32m\\]'") (reset . "'\\[\\033[00m\\]'")))

(define sss-bash-path-appends
  `("${KREW_ROOT:-$HOME/.krew}/bin" "$HOME/.local/bin"
    "$HOME/.guix-profile/bin"))

(define sss-bash-exports
  `((PS1 . "${grn}\"\\u@\\h \\w${GUIX_ENVIRONMENT:+ [env]} λ\"${clr}\"  \"")))

(begin
  (define* (sss-bash-aliases #:key clone-dir)
    `((".." . "cd ..;pwd") ("..." . "cd ../..;pwd")
      ("...." . "cd ../../..;pwd")
      (c . "clear")
      (h . "history")
      (tree . "tree --dirsfirst -F")
      (mkdir . "mkdir -p -v")
      (ll . "ls -lAh --group-directories-first")
      (l . "ls -lAh --group-directories-first")
      (e . "emacsclient -t")
      (vanilla-emacs . "emacs -Q")
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
  (export sss-bash-aliases))

(define sss-bash-functions
  `((glog . "sudo gzip -d \"$1.gz\" && cat \"$1\"")
    (hgrep . "history | grep \"$1\"")
    (flameshot-bash . "flameshot full -r>\"$1\"")))

(define-public sss-bash-postlude
  `("shopt -s histappend" "eval \"$(fzf --bash)\""
    "source /run/current-system/profile/etc/profile.d/nix.sh"))

(define (serialize-bash-alias a)
  (format #f "\nalias ~a=\"~a\""
          (car a)
          (cdr a)))

(define (serialize-bash-vars v)
  (format #f "\n~a=~a"
          (car v)
          (cdr v)))

(define (serialize-bash-path-appends a)
  (format #f "\nexport PATH=\"~a:$PATH\"" a))

(define (serialize-bash-exports e)
  (format #f "\nexport ~a=~a"
          (car e)
          (cdr e)))

(define (serialize-bash-function f)
  (format #f "\nfunction ~a () {\n\t~a\n}\n\n"
          (car f)
          (cond
            ((list? (cdr f))
             (string-join (cdr f) "\n\t"))
            (else (cdr f)))))

(begin
  (define* (sss-bash-config #:key clone-dir)
    (append '("# ====== SSS Bash configuration ======" "#"
              "# auto-generated file, DO NOT EDIT!")
            (map serialize-bash-vars sss-bash-vars)
            (map serialize-bash-exports sss-bash-exports)
            (map serialize-bash-function sss-bash-functions)
            (map serialize-bash-alias
                 (sss-bash-aliases #:clone-dir clone-dir))
            (map serialize-bash-path-appends sss-bash-path-appends)
            sss-bash-postlude))
  (export sss-bash-config))

(begin
  (define* (sss-bash-service #:key clone-dir)
    (simple-service 'sss-fancy-bash home-bash-service-type
                    (home-bash-extension (environment-variables '())
                                         (bashrc `(,(plain-file "bashrc.sh"
                                                                (string-join (sss-bash-config
                                                                              #:clone-dir
                                                                              clone-dir)
                                                                 "\n")))))))
  (export sss-bash-service))
