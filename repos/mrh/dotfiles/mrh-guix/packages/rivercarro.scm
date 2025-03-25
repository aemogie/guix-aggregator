(define-module (mrh-guix packages rivercarro)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system zig)
  #:use-module (gnu packages)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages zig))

(define (default-zig) zig-0.10) ; see (guix build-system zig) for def of zig-build-system

(define-public rivercarro
  (package
    (name "my-rivercarro")
    (version "0.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~novakane/rivercarro")
             (commit (string-append "v" version))
             (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1a852hkakha3f5djnd8jrmkcq0xcdxbcbidr2kkfbqrhni9p33cl"))))
    (build-system zig-build-system)
    (arguments
     `(#:tests? #f
       #:phases (modify-phases %standard-phases (delete 'validate-runpath))))
    (native-inputs (list pkg-config wayland wayland-protocols))
    (home-page "https://git.sr.ht/~novakane/rivercarro")
    (synopsis "A slightly modified version of rivertile layout generator for river")
    (description
     "A modified version of rivertile which adds: monocle layout, gaps rather than padding, gap size modification at run time, and smart gaps.")
    (license license:gpl3)))
