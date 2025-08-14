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

(define-module (sss enchant)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss prelude)
  #:export (enchant-capability enchant-ordering enchant-dict-en))

(define* (enchant-capability #:key (ordering enchant-ordering)
                             (en-dict enchant-dict-en))
  `((".enchant" ,(plain-file "enchant"
                             (mk-lines ordering)))
    (".aspell.en.pws" ,(plain-file "aspell.en.pws"
                                   (mk-lines (append (list
                                                      "personal_ws-1.1 en 0")
                                                     en-dict))))))

;; Enchant uses global and per-user ordering files named enchant.ordering to decide
;; which spelling provider to use for particular languages. The per-user file takes precedence.
;;
;; The ordering file takes the form language_tag:<comma-separated list of spelling providers>.
;; To see what dictionaries are available, run enchant-lsmod-2.
;; ’*’ is used to mean use this ordering for all languages, unless instructed otherwise.
(define enchant-ordering
  `("*:aspell"))

;; Custom dictionary for English
(define enchant-dict-en
  `("Guix" "Hyprland"
    "aspell"
    "hunspell"
    "Sexp"
    "MERCHANTABILITY"
    "byggsteg"
    "wikimusic"
    "repo"
    "zio"
    "nuspell"
    "sss"
    "Josep"
    "pws"
    "ws"
    "defcustom"
    "setq"
    "src"
    "emacs"
    "init"
    "mkdir"
    "pkill"
    "fastfetch"
    "emacsclient"
    "usr"
    "env"
    "dirsfirst"
    "lAh"
    "monospace"
    "Consolas"
    "sbt"
    "direnv"
    "gtk"
    "ini"
    "newstyle"
    "gitignore"
    "gitconfig"
    "includeIf"
    "gitdir"
    "Xservers"
    "Xcursor"
    "Bigorra"
    "Algaba"))
