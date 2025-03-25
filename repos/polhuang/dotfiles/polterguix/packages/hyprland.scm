(define-module (polterguix packages hyprland)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages file)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages image)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages linux)
  #:use-module (rosenthal packages wm))

(define-public hyprutils
  (package
    (name "hyprutils")
    (version "0.2.1")
    (source (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/hyprwm/hyprutils.git")
                   (commit (string-append "v" version))))
             (file-name (git-file-name name version))
             (sha256
              (base32 "0nxx5yb5k9726x95n8gi27xyxyzwb0ma0nj3czpb51sda1k0hz0g"))))
    (build-system cmake-build-system)
    (arguments
     '(#:configure-flags '("-DCMAKE_BUILD_TYPE=Release")))
    (native-inputs
     (list pkg-config
           pixman
           gcc-13))
    (home-page "https://github.com/hyprwm/hyprutils")
    (synopsis "HyprWM utilities library used across the ecosystem")
    (description
     "Hyprutils is a small C++ library for utilities used across the Hypr* ecosystem.")
    (license license:bsd-3)))

(define-public hyprwayland-scanner
  (package
    (name "hyprwayland-scanner")
    (version "0.4.0")
    (source (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/hyprwm/hyprwayland-scanner.git")
                   (commit (string-append "v" version))))
             (file-name (git-file-name name version))
             (sha256
              (base32 "1xc2xcxpq61lg964ihk0wbfzqqvibw20iz09g0p33ym51gwlpxr4"))))
    (build-system cmake-build-system)
    (arguments
     '(#:configure-flags '("-DCMAKE_BUILD_TYPE=Release")
       #:tests? #f))
    (native-inputs
     (list pkg-config
           gcc-13
           pugixml))
    (home-page "https://github.com/hyprwm/hyprwayland-scanner")
    (synopsis "A Hyprland implementation of wayland-scanner, in and for C++.")
    (description
     "A Hyprland implementation of wayland-scanner, in and for C++.")
    (license license:bsd-3)))

(define wayland-protocols-for-hyprland
  (package
    (inherit wayland-protocols)
    (name "wayland-protocols")
    (version "1.36")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://gitlab.freedesktop.org/wayland/wayland-protocols"
                    "/-/releases/" version "/downloads/"
                    "wayland-protocols-" version ".tar.xz"))
              (sha256
               (base32
                "14kyxywpfkgpjpkrybs28q1s2prnz30k1b4zap5a3ybrbvh4vzbi"))))))

(define-public hyprpaper
  (package
   (name "hyprpaper")
   (version "0.7.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/hyprwm/hyprpaper.git")
                  (commit (string-append "v" version))))
           (file-name (git-file-name name version))
           (sha256
            (base32 "10yb2853fd0ljxijwkqm146bnirzpghfc5kw080ws24hjmfbp0hw"))))
  (build-system cmake-build-system)
  (arguments
   '(#:configure-flags '("-DCMAKE_BUILD_TYPE=Release")
     #:tests? #f))
  (native-inputs
   (list pkg-config
         gcc-13))
  (inputs
   (list cairo
         file
         wayland
         wayland-protocols-for-hyprland
         pango
         cairo
         file
         libglvnd
         libjpeg-turbo
         libwebp
         hyprlang
         hyprutils
         hyprwayland-scanner))
  (home-page "https://github.com/hyprwm/hyprpaper")
  (synopsis "Hyprpaper is a blazing fast wayland wallpaper utility with IPC controls.")
  (description "Hyprpaper is a blazing fast wallpaper utility for Hyprland with the ability to dynamically change wallpapers through sockets.")
  (license license:bsd-3)))

(define-public hypridle
  (package
   (name "hypridle")
   (version "0.1.2")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/hyprwm/hypridle.git")
                  (commit (string-append "v" version))))
           (file-name (git-file-name name version))
           (sha256
            (base32 "10l0yxy1avryjj54gimw2blhl7348dypyhh43b73a8ncjicpjnzc"))))
  (build-system cmake-build-system)
  (arguments
   '(#:tests? #f))
  (native-inputs
   (list pkg-config
         gcc-13))
  (inputs
   (list wayland
         wayland-protocols-for-hyprland
         hyprlang
         sdbus-c++))
  (home-page "https://github.com/hyprwm/hypridle")
  (synopsis "Hyprland's idle daemon")
  (description "Hyprland's idle daemon")
  (license license:bsd-3)))

