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

(define-module (sss packages fonts)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system font)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages fontutils))

(define-public font-adwaita
  (package
    (name "font-adwaita")
    (version "48.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://download.gnome.org/sources/adwaita-fonts/48/adwaita-fonts-48.0.tar.xz")
       (sha256
        (base32 "05slzfhb5488v94syrry9jfbldaid6xpnq54dac6zq8qv4lz8bhx"))))
    (build-system font-build-system)
    (home-page "https://gitlab.gnome.org/GNOME/adwaita-fonts")
    (synopsis "Adwaita font families, sans and mono")
    (description
     "Adwaita Sans, a variation of Inter, and Adwaita Mono, Iosevka customized to match Inter.")
    (license license:gpl3+)))

(define-public font-inter
  (package
    (name "font-inter")
    (version "4.1")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/rsms/inter/releases/download/v4.1/Inter-4.1.zip")
       (sha256
        (base32 "07miarbl5ain7pg7sxlrb2j4m9prbriacyqpv1mvckwxlkagv0wq"))))
    (build-system font-build-system)
    (home-page "https://github.com/rsms/inter")
    (synopsis "Inter is a sans serif font family with high readability.")
    (description
     "Inter is a typeface carefully crafted & designed for computer screens. Inter features a tall x-height to aid in readability of mixed-case and lower-case text. Inter is a variable font with several OpenType features, like contextual alternates that adjusts punctuation.")
    (license license:silofl1.1)))

(define-public font-monaspace
  (package
    (name "font-monaspace")
    (version "1.101")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/githubnext/monaspace/archive/refs/tags/v1.101.tar.gz")
       (sha256
        (base32 "076gx85and4xb262y0rbqvy7f6w732krzlh236xr7v3zbsw1h872"))))
    (build-system font-build-system)
    (home-page "https://monaspace.githubnext.com")
    (synopsis "An innovative superfamily of fonts for code")
    (description
     "The Monaspace type system is a monospaced type superfamily with some modern tricks up its sleeve.
     It consists of five variable axis typefaces. Each one has a distinct voice, but they are all metrics-compatible with one another,
     allowing you to mix and match them for a more expressive typographical palette.")
    (license license:silofl1.1)))

