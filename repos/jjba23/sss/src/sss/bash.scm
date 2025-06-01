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
  #:use-module (gnu home services shells)
  #:export (bash-vars bash-path-appends
                      bash-exports
                      bash-aliases
                      bash-functions
                      bash-postlude
                      serialize-bash-alias
                      serialize-bash-var
                      serialize-bash-path-append
                      serialize-bash-export
                      serialize-bash-function
                      bash-config
                      bash-capability))

(define bash-vars
  (make-parameter `((green . "'\\[\\033[01;32m\\]'")
                    (reset . "'\\[\\033[00m\\]'"))))

(define bash-path-appends
  (make-parameter `("${KREW_ROOT:-$HOME/.krew}/bin" "$HOME/.local/bin"
                    "$HOME/.guix-profile/bin")))

(define bash-exports
  (make-parameter `((PS1 . "${grn}\"\\u@\\h \\w${GUIX_ENVIRONMENT:+ [env]} λ\"${clr}\"  \""))))

(define* (bash-aliases #:key clone-dir gui-cmd)
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
    (gui unquote gui-cmd)
    (find-largest-files . "du -h -x -s -- * | sort -r -h | head -20")))

(define bash-functions
  (make-parameter `((glog . "sudo gzip -d \"$1.gz\" && cat \"$1\"")
                    (hgrep . "history | grep \"$1\"")
                    (flameshot-bash . "flameshot full -r>\"$1\""))))

(define-public bash-postlude
  `("shopt -s histappend" "eval \"$(fzf --bash)\""
    "source /run/current-system/profile/etc/profile.d/nix.sh"))

(define (serialize-bash-alias a)
  (format #f "\nalias ~a=\"~a\""
          (car a)
          (cdr a)))

(define (serialize-bash-var v)
  (format #f "\n~a=~a"
          (car v)
          (cdr v)))

(define (serialize-bash-path-append a)
  (format #f "\nexport PATH=\"~a:$PATH\"" a))

(define (serialize-bash-export e)
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

(define* (bash-config #:key clone-dir gui-cmd)
  (append '("# ====== SSS Bash configuration ======" "#"
            "# auto-generated file, DO NOT EDIT!")
          (map serialize-bash-var
               (bash-vars))
          (map serialize-bash-export
               (bash-exports))
          (map serialize-bash-function
               (bash-functions))
          (map serialize-bash-alias
               (bash-aliases #:clone-dir clone-dir
                             #:gui-cmd gui-cmd))
          (map serialize-bash-path-append
               (bash-path-appends))
          bash-postlude))

(define* (bash-capability #:key clone-dir gui-cmd)
  (simple-service 'bash-capability home-bash-service-type
                  (home-bash-extension (environment-variables '())
                                       (bashrc `(,(plain-file "bashrc.sh"
                                                              (string-join (bash-config
                                                                            #:clone-dir
                                                                            clone-dir
                                                                            #:gui-cmd
                                                                            gui-cmd)
                                                                           "\n")))))))

