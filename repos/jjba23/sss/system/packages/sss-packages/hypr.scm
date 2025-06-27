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

(define-module (sss-packages hypr)
  #:declarative? #t
  #:use-module (guix build-system cmake)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:export (hypr-packages))

(define-public hyprsunset
  (package
    (name "hyprsunset")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hyprwm/hyprsunset")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "110cw7nd6a0krsg6764hx2i45lc8n4b1iln3b8jz1x6pziw1qna9"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f)) ;No tests.
    (native-inputs (list gcc-14 pkg-config))
    (inputs (list hyprwayland-scanner hyprutils wayland hyprland-protocols
                  wayland-protocols))
    (home-page "https://wiki.hypr.land/Hypr-Ecosystem/hyprsunset/")
    (synopsis "Blue-light filter for Hyprland")
    (description
     "This is a small utility to provide a blue light filter for your system.
This method is preferred to screen shaders as it will not be captured
via recording / screenshots.

hyprsunset also provides a gamma filter, which can be used to adjust perceived
display brightness on monitors that do not support software control, or to
reduce percieved brightness below the monitor's minimum.")
    (license license:bsd-3)))

(define hypr-packages
  (make-parameter (list hyprland
                        hypridle
                        hyprcursor
                        hyprlock
                        hyprpicker
                        hyprsunset)))
