(define-module (yggdrasil packages clojure)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages compression)
  #:use-module (nonguix build-system binary)
  #:use-module (guix build-system copy))

(define-public babashka
  (package
    (name "babashka")
    (version "0.10.163")
    (source
     (origin
       (method url-fetch)
       (uri
        (string-append
         "https://github.com/babashka/babashka/releases/download/v"
         version "/babashka-" version "-linux-amd64.tar.gz"))
       (sha256
        (base32 "1d2wx1sjny9bhazyld275azk2zl1gs5xvnyy6p3vgxcyljvl94m1"))))
    (build-system binary-build-system)
    (supported-systems '("x86_64-linux" "i686-linux"))
    (arguments
     `(#:patchelf-plan
       `(("bb" ("libc" "zlib" "libstdc++")))
       #:install-plan
       `(("." ("bb") "bin/"))
       #:phases
       (modify-phases
           %standard-phases
         ;; this is required because standard unpack expects the archive to
         ;; contain a directory with everything inside it, while babashka's
         ;; release file only contains the `bb` binary.
         (replace 'unpack
           (lambda* (#:key inputs outputs source #:allow-other-keys)
             (invoke "tar" "xf" source)
             #t)))))
    (inputs
     `(("libstdc++" ,(make-libstdc++ gcc))
       ("zlib" ,zlib)))
    (synopsis
     "Fast native Clojure scripting runtime")
    (description
     "Babashka is a native Clojure interpreter for scripting with fast startup.
Its main goal is to leverage Clojure in places where you would be using bash otherwise.")
    (home-page "https://babashka.org/")
    (license license:epl1.0)))

(define-public clj-kondo
 (package
   (name "clj-kondo")
   (version "2022.10.05")
   (source (origin
             (method url-fetch/zipbomb)
             (uri (string-append
                   "https://github.com/clj-kondo/clj-kondo/releases/download/v"
                   version "/clj-kondo-" version "-linux-amd64.zip"))
             (sha256
              (base32
               "0qj5zl2s8r2gdl914jyddlm361x49q84mfz0x1szvhzj895zjphg"))))
   (build-system binary-build-system)
   (arguments
    `(#:patchelf-plan
      '(("clj-kondo" ("gcc:lib" "zlib")))
      #:install-plan
      '(("clj-kondo" "/bin/"))
      #:phases
      (modify-phases %standard-phases
         (add-after 'unpack 'chmod
           (lambda _
             (chmod "clj-kondo" #o755))))))
   (native-inputs
    `(("unzip" ,unzip)))
   (inputs
    `(("gcc:lib" ,gcc "lib")
      ("zlib" ,zlib)))
   (supported-systems '("x86_64-linux"))
   (home-page "https://github.com/clj-kondo/clj-kondo")
   (synopsis  "Linter for Clojure code")
   (description "Clj-kondo performs static analysis on Clojure, ClojureScript
and EDN, without the need of a running REPL.")
   (license license:epl1.0)))

(define-public clojure-lsp
  (package
    (name "clojure-lsp")
    (version "2023.07.01-22.35.41")
    (source (origin
              (method url-fetch/zipbomb)
              (uri (string-append
                    "https://github.com/clojure-lsp/clojure-lsp/releases/download/"
		    version
		    "/clojure-lsp-native-static-linux-amd64.zip"))
              (sha256
               (base32
		"0a93fjrslyqrj1in49a51b0hnrjmgjamxxg39y9h9b9xpsy1dwcz"))))
    (build-system copy-build-system)
    (arguments
    `(#:install-plan
      '(("clojure-lsp" "/bin/"))))
    (native-inputs
     `(("unzip" ,unzip)))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/clojure-lsp/clojure-lsp")
    (synopsis  "")
    (description "")
    (license license:expat)))
