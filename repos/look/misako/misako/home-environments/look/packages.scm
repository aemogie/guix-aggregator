(define-module (misako home-environments look packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix transformations)
  #:use-module (guix utils)
  #:use-module (saayix packages terminals)
  #:export (ghostty-tip
            hyprland-latest))

(define ghostty-tip
  ((options->transformation
     '((with-commit . "ghostty=9d9d781a0b7142ddc176167ef5e889618d295ef5")))
   ghostty))

(define hyprland-latest
  (let* ((commit "8e9add2afda58d233a75e4c5ce8503b24fa59ceb")
         (revision "1"))
    (package/inherit hyprland
      (name (package-name hyprland))
      (version (git-version "0.51.1" revision commit))
      (source
        (origin
          (method git-fetch)
          (uri
            (git-reference
              (url "https://github.com/hyprwm/Hyprland")
              (commit commit)))
          (file-name (git-file-name name version))
          (sha256
           (base32 "0hnq8vwr31scpf20qnv17zc0fn7llf0wlhym0a8p39n6ag1g1dwc")))))))
