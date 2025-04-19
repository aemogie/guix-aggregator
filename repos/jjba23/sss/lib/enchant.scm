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

(load "./process.scm")

(define-module (sss enchant)
  #:use-module (gnu)
  #:use-module (sss process))

(begin
  (define* (sss-enchant-svc #:key (ordering sss-enchant-ordering)
                            (en-dict sss-enchant-dict-en))
    `((".enchant" ,(plain-file "enchant"
                               (mk-lines ordering)))
      (".config/enchant/en_US.dic" ,(plain-file "en_US.dic"
                                                (mk-lines en-dict)))))
  (export sss-enchant-svc))

;; Enchant uses global and per-user ordering files named enchant.ordering to decide
;; which spelling provider to use for particular languages. The per-user file takes precedence.
;;
;; The ordering file takes the form language_tag:<comma-separated list of spelling providers>.
;; To see what dictionaries are available, run enchant-lsmod-2.
;; ’*’ is used to mean use this ordering for all languages, unless instructed otherwise.
(define-public sss-enchant-ordering
  `("*:aspell,hunspell,nuspell"))

;; Custom dictionary for English
(define-public sss-enchant-dict-en
  `("Guix" "Hyprland"
    "aspell"
    "hunspell"
    "Sexp"
    "byggsteg"
    "wikimusic"
    "repo"
    "zio"
    "nuspell"
    "sss"
    "Josep"
    "Bigorra"
    "Algaba"))

