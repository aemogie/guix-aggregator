(define-module (yggdrasil packages pipewire)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages crates-gtk)
  #:use-module (yggdrasil packages crates-gtk)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages freedesktop)

  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages rust)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system cargo)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages))

(define-public helvum
  (package
    (name "helvum")
    (version "0.4.0")
    (home-page "https://gitlab.freedesktop.org/pipewire/helvum")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url home-page)
             (commit version)))
       (sha256
        (base32
         "1hlqyy8d1dla0npm2namsw00plrjn9spjiymjs06jv58y7nwxy2f"))
       (file-name (git-file-name name version))))
    (build-system meson-build-system)
    (arguments
     (list
      #:imported-modules (append %cargo-build-system-modules
                                 %meson-build-system-modules)
      #:modules
      `(((guix build cargo-build-system) #:prefix cargo:)
        ,@%meson-build-system-modules)
      #:phases
      #~(modify-phases (@ (guix build meson-build-system) %standard-phases)
          (add-before 'configure 'configure-cargo
            (lambda* (#:key inputs #:allow-other-keys)
              ((assoc-ref cargo:%standard-phases 'unpack-rust-crates)
               #:inputs inputs
               #:vendor-dir "guix-vendor")
              ((assoc-ref cargo:%standard-phases 'configure)
               #:inputs inputs)
              ((assoc-ref cargo:%standard-phases 'patch-cargo-checksums))
              (substitute* "src/meson.build"
                (("cargo-home") ".cargo")
                (("cargo_options = .*" opts)
                 (string-append
                  opts
                  "cargo_options += \
[ '--config', meson.project_source_root() / '.cargo' / 'config' ]\n"))))))))
    (inputs (list pipewire
		  glib
		  gtk
		  desktop-file-utils

                  rust-glib-0.17
                  rust-gtk4-0.6
                  rust-log-0.4
                  rust-once-cell-1))
    (native-inputs (list rust
			 `(,rust "cargo")
			 `(,gtk "bin")
			 clang-3.7
			 pkg-config))
    (synopsis "")
    (description "")
    (license license:expat)))

helvum
