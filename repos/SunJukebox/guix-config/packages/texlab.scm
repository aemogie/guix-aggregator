(define-module (anon packages texlab)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (nonguix build-system binary))

(define-public texlab
  (package
    (name "texlab-bin")
    (version "5.20.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/latex-lsp/texlab/releases/download/v"
             version
             "/texlab-x86_64-linux.tar.gz"))
       (sha256
        (base32
         "024am541hrhbk52n15h03j1j15r33497dr2gypwli4b3rx30grj3"))))
    (build-system binary-build-system)
    (arguments
     `(#:install-plan
       `(("texlab" "/bin/"))
       #:patchelf-plan
       `(("texlab" ("libgccjit")))
       #:phases
       (modify-phases %standard-phases
         (delete 'binary-unpack)
         (replace 'unpack
           (lambda* (#:key inputs #:allow-other-keys)
             (invoke "tar" "-xvzf" (assoc-ref inputs "source")))))))
    (inputs
     `(("libgccjit" ,libgccjit)))
    (native-inputs
     `(("gzip" ,gzip)))
    (synopsis "An implementation of the Language Server Protocol for LaTeX ")
    (description "A cross-platform implementation of the Language Server Protocol providing rich cross-editing support for the LaTeX typesetting system. The server may be used with any editor that implements the Language Server Protocol.")
    (home-page "https://texlab.netlify.app/")
    (license license:gpl3)))
