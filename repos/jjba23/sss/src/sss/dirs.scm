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

(define-module (sss dirs)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss process)
  #:export (sss-dirs-svc))

(define* (sss-dirs-svc #:key (desktop-dir "$HOME/desktop")
                       (documents-dir "$HOME/documents")
                       (downloads-dir "$HOME/downloads")
                       (music-dir "$HOME/music")
                       (pictures-dir "$HOME/pictures")
                       (public-dir "$HOME/public")
                       (templates-dir "$HOME/templates")
                       (videos-dir "$HOME/videos"))
  `((".config/user-dirs.dirs" ,(plain-file "nix.conf"
                                           (mk-rec-kv-conf-lines `((XDG_DESKTOP_DIR
                                                                    unquote
                                                                    desktop-dir)
                                                                   (XDG_DOCUMENTS_DIR
                                                                    unquote
                                                                    documents-dir)
                                                                   (XDG_DOWNLOAD_DIR
                                                                    unquote
                                                                    downloads-dir)
                                                                   (XDG_MUSIC_DIR
                                                                    unquote
                                                                    music-dir)
                                                                   (XDG_PICTURES_DIR
                                                                    unquote
                                                                    pictures-dir)
                                                                   (XDG_PUBLICSHARE_DIR
                                                                    unquote
                                                                    public-dir)
                                                                   (XDG_TEMPLATES_DIR
                                                                    unquote
                                                                    templates-dir)
                                                                   (XDG_VIDEOS_DIR
                                                                    unquote
                                                                    videos-dir))
                                            #:template
                                            equal-conf-quote-value-pair)))
    
    ))

