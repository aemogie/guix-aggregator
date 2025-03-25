(define-module (yggdrasil packages security-token)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages security-token))

(define-public yubikey-oath-dmenu-with-wtype
  (package/inherit yubikey-oath-dmenu
    (inputs
     (modify-inputs (package-inputs yubikey-oath-dmenu)
       (append wtype)))
    (arguments
     (substitute-keyword-arguments (package-arguments yubikey-oath-dmenu)
       ((#:phases phases)
        #~(modify-phases #$phases
            (replace 'fix-paths
              (lambda* (#:key inputs #:allow-other-keys)
                (substitute* "yubikey-oath-dmenu.py"
                  (("'(dmenu|notify-send|wl-copy|xclip|xdotool|wtype)" _ tool)
                   (string-append
                    "'"
                    (search-input-file inputs
                                       (string-append "/bin/" tool)))))))))))))
