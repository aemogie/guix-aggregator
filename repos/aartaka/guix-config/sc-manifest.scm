(use-modules (gnu packages)
             (gnu packages audio)
             (gnu packages compression)
             (gnu packages gcc)
             (gnu packages linux)
             (gnu packages music)
             (gnu packages emacs-xyz)
             (gnu packages sdl)

             (guix download)
             (guix packages)

             (ice-9 match)

             (nongnu packages music)

             (nonguix build-system binary)
             ((nonguix licenses) #:prefix license:))

;; Until nonguix accepts a patch.
(define sunvox
  (package
    (name "sunvox")
    (version "2.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://warmplace.ru/soft/sunvox/sunvox-" version "c.zip"))
       (sha256
        (base32 "0g6avkc2azp44d0g4m1m23r38gnmg7v9a1fbp2yv6ma0v5p5rxf8"))))
    (build-system binary-build-system)
    (arguments
     `(#:patchelf-plan '((,(string-append "sunvox/"
                                          (match (%current-system)
                                            ("x86_64-linux" "linux_x86_64")
                                            ("i686-linux" "linux_x86")
                                            ("aarch64-linux" "linux_arm64")
                                            ("armhf-linux" "linux_arm"))
                                          "/sunvox")
                          ("libc" "gcc" "alsa-lib" "sdl2")))
       #:install-plan '(("curves" "share/curves")
                        ("docs" "share/docs")
                        ("effects" "share/effects")
                        ("examples" "share/examples")
                        ("instruments" "share/instruments")
                        (,(string-append "sunvox/"
                                         (match (%current-system)
                                           ("x86_64-linux" "linux_x86_64")
                                           ("i686-linux" "linux_x86")
                                           ("aarch64-linux" "linux_arm64")
                                           ("armhf-linux" "linux_arm"))
                                         "/sunvox")
                         "share/sunvox/linux/sunvox"))
       #:validate-runpath? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'make-wrapper
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (real (string-append out "/share/sunvox/linux/sunvox"))
                    (wrapper (string-append out "/bin/sunvox")))
               (mkdir-p (dirname wrapper))
               (symlink real wrapper))
             #t)))))
    (inputs
     (list
      alsa-lib
      sdl2
      unzip
      `(,gcc "lib")))
    (supported-systems '("x86_64-linux" "i686-linux" "aarch64-linux"
                         "armhf-linux"))
    (home-page "https://warmplace.ru/soft/sunvox/")
    (synopsis "Modular synthesizer and tracker.")
    (description
     "SunVox is a small, fast and powerful modular synthesizer with
pattern-based sequencer (tracker). Features:
@itemize
@item Support for variety of systems and audio formats.
@item Real-time sample/MIDI/audio signal playback and recording.
@item Generative music utilities.
@item Lots of built-in modules.
@end itemize")
    (license (license:nonfree "file:///share/docs/license/sunvox.txt"))))

(packages->manifest
 (list
  ;; Audio infrastructure
  jack-1 alsa-lib sdl2
  ;; SuperCollider (broken)
  supercollider emacs-scel
  ;; PureData
  pd libpd
  ;; SunVox
  sunvox))
