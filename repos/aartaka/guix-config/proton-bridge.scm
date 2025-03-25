(use-modules (gnu)
             (gnu packages base)
             (gnu packages gcc)
             (gnu packages gl)
             (gnu packages glib)
             (gnu packages gnome)
             (gnu packages gtk)
             (gnu packages qt)

             (nonguix build-system binary)
             (guix download)
             (guix packages)
             ((guix licenses) #:prefix license:))

(define-public proton-bridge
  (let ((version "1.8.3"))
    (package
      (name "protonmail-bridge")
      (version version)
      ;;; Replace with this if downloaded locally:
      ;; (source (local-file "/path/to/protonmail-bridge_1.8.9-1_amd64.deb" #:recursive? #t))
      (source
       (origin
         (method url-fetch)
         (uri "https://protonmail.com/download/bridge/protonmail-bridge_1.8.9-1_amd64.deb")
         (sha256
          (base32 "06riilfn6429ips4akjnbmxzb30l0x8254bxbi3sldnmsb0y2fbl"))))
      (supported-systems '("x86_64-linux"))
      (build-system binary-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (replace 'unpack
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let ((data (string-append (assoc-ref outputs "out") "/data")))
                 (mkdir-p data)
                 (invoke "ar" "x" (assoc-ref inputs "source"))
                 (invoke "tar" "-xz" "-f" "data.tar.gz"))
               #t)))
         #:strip-binaries? #f
         #:patchelf-plan
         `(("usr/lib/protonmail/bridge/proton-bridge"
            ("libc" "gcc:lib" "qtbase" "qtdeclarative" "qtsvg" "libsecret" "gtk" "glib" "libglvnd")))
         #:install-plan
         `(("usr/lib/protonmail/bridge/proton-bridge" () "bin/proton-bridge"))))
      (inputs `(("gcc:lib" ,gcc "lib")
                ("glu" ,glu)
                ("libglvnd" ,libglvnd)
                ("glib" ,glib)
                ("libsecret" ,libsecret)
                ("gtk" ,gtk+)
                ("qtbase" ,qtbase-5)
                ("qtdeclarative" ,qtdeclarative)
                ("qtsvg" ,qtsvg)))
      (synopsis "ProtonMail Bridge application.")
      (description "An application that runs on your computer in the
background and seamlessly encrypts and decrypts your mail as it enters
and leaves your computer.")
      (home-page "https://www.protonmail.com/bridge")
      (license license:gpl3+))))

proton-bridge
