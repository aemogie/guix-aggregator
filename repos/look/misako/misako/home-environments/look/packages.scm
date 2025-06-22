(define-module (misako home-environments look packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages wm)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix transformations)
  #:use-module (guix utils)
  #:use-module (saayix packages terminals)
  #:export (ghostty-tip
            hyprland-git/latest))

(define ghostty-tip
  ((options->transformation
     '((with-commit . "ghostty=9d9d781a0b7142ddc176167ef5e889618d295ef5")))
   ghostty))

(define hyprland-git
  (package/inherit hyprland
    (version (package-version hyprland))
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/hyprwm/Hyprland")
               (commit (string-append "v" version))))
        (file-name (git-file-name (package-name hyprland) version))
        (sha256
          (base32 "0n1bxbp9a5v73hzywv8pw9i5y9qm36q25crs07mkwmfsh9xhdpc8"))))))

(define hyprland-git/latest
  (let* ((hyprland-latest ((options->transformation
                             '((with-commit . "hyprland=bef1321f00e260ee3031aecd02faf4f53bcb5c66")))
                           hyprland-git))
         (libinput-minimal-latest ((options->transformation
                                     '((with-version . "libinput-minimal=1.28.1")))
                                   libinput-minimal)))
    (package/inherit hyprland-latest
      (inputs
        (modify-inputs (package-inputs hyprland-latest)
          (replace "libinput-minimal" libinput-minimal-latest)))
      (native-inputs
        (modify-inputs (package-native-inputs hyprland-latest)
          (replace "gcc" gcc-15))))))
