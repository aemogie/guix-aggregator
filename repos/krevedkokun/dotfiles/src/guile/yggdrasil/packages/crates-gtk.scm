(define-module (yggdrasil packages crates-gtk)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages crates-gtk)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages pkg-config)
  #:use-module (guix build-system cargo)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define-public rust-glib-sys-0.17
  (package/inherit rust-glib-sys-0.15
    (name "rust-glib-sys")
    (version "0.17.4")
    (source
     (origin
       (inherit (package-source rust-glib-sys-0.15))
       (uri (crate-uri "glib-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "19c0ars1rpcyfx7k63k2pghxjh898f1mvwgzmmhqwm5zl780mw29"))))))

(define-public rust-glib-macros-0.17
  (package/inherit rust-glib-macros-0.15
    (name "rust-glib-macros")
    (version "0.17.9")
    (source
     (origin
       (inherit (package-source rust-glib-macros-0.15))
       (uri (crate-uri "glib-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0zxr3fh7r2g4jk35p7brzdjngp8zx284ji51dq9fyl9qq32hcwha"))))))

(define-public rust-gobject-sys-0.17
  (package/inherit rust-gobject-sys-0.15
    (name "rust-gobject-sys")
    (version "0.17.4")
    (source
     (origin
       (inherit (package-source rust-gobject-sys-0.15))
       (uri (crate-uri "gobject-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l4kcw17y6dxb6b6wkw4f2ly624kmxbghg6av2r34im60005prqm"))))
    (arguments
     (substitute-keyword-arguments (package-arguments rust-gobject-sys-0.15)
       ((#:cargo-inputs inputs)
        (modify-inputs inputs
          (replace "rust-glib-sys" rust-glib-sys-0.17)))))))

(define-public rust-gio-sys-0.17
  (package/inherit rust-gio-sys-0.15
    (name "rust-gio-sys")
    (version "0.17.4")
    (source
     (origin
       (inherit (package-source rust-gio-sys-0.15))
       (uri (crate-uri "gio-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19b2wdwdn6gbjnqac2klymbi51wj27jazv24a92li2wnsyq467bb"))))
    (arguments
     (substitute-keyword-arguments (package-arguments rust-gio-sys-0.15)
       ((#:cargo-inputs inputs)
        (modify-inputs inputs
          (replace "rust-gobject-sys" rust-gobject-sys-0.17)
          (replace "rust-glib-sys" rust-glib-sys-0.17)))))))

(define-public rust-gio-0.17
  (package
    (name "rust-gio")
    (version "0.17.9")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gio" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "14nbsx934f5l06v34ln2q3s6lxq6zfy5rhpb79x6zjvbdkjj4ifi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-futures-channel" ,rust-futures-channel-0.3)
        ("rust-futures-core" ,rust-futures-core-0.3)
        ("rust-futures-io" ,rust-futures-io-0.3)
        ("rust-futures-util" ,rust-futures-util-0.3)
        ("rust-gio-sys" ,rust-gio-sys-0.17)
        ("rust-glib" ,rust-glib-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-once-cell" ,rust-once-cell-1)
        ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
        ("rust-smallvec" ,rust-smallvec-1)
        ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the Gio library")
    (description "Rust bindings for the Gio library")
    (license license:expat)))

(define-public rust-trybuild2-1
  (package/inherit rust-trybuild-1
    (name "rust-trybuild")
    (version "1.0.2")
    (source
     (origin
       (inherit (package-source rust-trybuild-1))
       (uri (crate-uri "trybuild2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "06i4fllj4pi595vn4jrixmyfa9vdn4g59l7ws8knlhry83f6fpd6"))))
    (arguments
     (substitute-keyword-arguments (package-arguments rust-trybuild-1)
       ((#:tests? _ #f) #f)
       ((#:cargo-development-inputs _ ''())
        `(("rust-automod" ,rust-automod-1)))))))

(define-public rust-glib-0.17
  (package/inherit rust-glib-0.15
    (name "rust-glib")
    (version "0.17.9")
    (source
     (origin
       (inherit (package-source rust-glib-0.15))
       (uri (crate-uri "glib" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dh9bw7q9i2d4nnzh20fnzam8pffrqnkli8rm7qa87p3pmydxwd7"))))
    (arguments
     (substitute-keyword-arguments (package-arguments rust-glib-0.15)
       ((#:cargo-inputs inputs)
        (modify-inputs inputs
          (prepend rust-gio-sys-0.17)
          (replace "rust-glib-macros" rust-glib-macros-0.17)
          (replace "rust-glib-sys" rust-glib-sys-0.17)))
       ((#:cargo-development-inputs inputs)
        (modify-inputs inputs
          (delete "rust-futures-util")
          (prepend rust-criterion-0.4)
          (prepend rust-trybuild2-1)))))))

(define-public rust-gtk4-sys-0.6
  (package
    (name "rust-gtk4-sys")
    (version "0.6.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gtk4-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0bz26ix7pl4d1m63zacaw1vw5021vm5r7wn7fsg02zmh0zvq70jz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-cairo-sys-rs" ,rust-cairo-sys-rs-0.17)
        ("rust-gdk-pixbuf-sys" ,rust-gdk-pixbuf-sys-0.17)
        ("rust-gdk4-sys" ,rust-gdk4-sys-0.6)
        ("rust-gio-sys" ,rust-gio-sys-0.17)
        ("rust-glib-sys" ,rust-glib-sys-0.17)
        ("rust-gobject-sys" ,rust-gobject-sys-0.17)
        ("rust-graphene-sys" ,rust-graphene-sys-0.17)
        ("rust-gsk4-sys" ,rust-gsk4-sys-0.6)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-pango-sys" ,rust-pango-sys-0.17)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "http://gtk-rs.org/")
    (synopsis "FFI bindings of GTK 4")
    (description "FFI bindings of GTK 4")
    (license license:expat)))

(define-public rust-quick-xml-0.27
  (package
    (name "rust-quick-xml")
    (version "0.27.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quick-xml" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0hacs71afvppq6d7x6b8d4liv0rcqhsf9mrcyrb8lxnxazq57h7z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-document-features" ,rust-document-features-0.2)
        ("rust-encoding-rs" ,rust-encoding-rs-0.8)
        ("rust-memchr" ,rust-memchr-2)
        ("rust-serde" ,rust-serde-1)
        ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/tafia/quick-xml")
    (synopsis "High performance xml reader and writer")
    (description "High performance xml reader and writer")
    (license license:expat)))

(define-public rust-gtk4-macros-0.6
  (package
    (name "rust-gtk4-macros")
    (version "0.6.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gtk4-macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "03shq84fvay3zqdccr2j22v6kkdi8fj4v61dakpd6xhgaxhnnkba"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-anyhow" ,rust-anyhow-1)
        ("rust-proc-macro-crate" ,rust-proc-macro-crate-1)
        ("rust-proc-macro-error" ,rust-proc-macro-error-1)
        ("rust-proc-macro2" ,rust-proc-macro2-1)
        ("rust-quick-xml" ,rust-quick-xml-0.27)
        ("rust-quote" ,rust-quote-1)
        ("rust-syn" ,rust-syn-1))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Macros helpers for GTK 4 bindings")
    (description "Macros helpers for GTK 4 bindings")
    (license license:expat)))

(define-public rust-gsk4-sys-0.6
  (package
    (name "rust-gsk4-sys")
    (version "0.6.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gsk4-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1c013zdd0yzcfmkz1gj28dbfz2zmypi8baimjk9264yg9pxq8yn0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-cairo-sys-rs" ,rust-cairo-sys-rs-0.17)
        ("rust-gdk4-sys" ,rust-gdk4-sys-0.6)
        ("rust-glib-sys" ,rust-glib-sys-0.17)
        ("rust-gobject-sys" ,rust-gobject-sys-0.17)
        ("rust-graphene-sys" ,rust-graphene-sys-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-pango-sys" ,rust-pango-sys-0.17)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "http://gtk-rs.org/")
    (synopsis "FFI bindings of GSK 4")
    (description "FFI bindings of GSK 4")
    (license license:expat)))

(define-public rust-gsk4-0.6
  (package
    (name "rust-gsk4")
    (version "0.6.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gsk4" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0g1srhahmhdl6rqbz98bawzf1gp6hf9m4y4rvbi1bb3wz92fy0bg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-cairo-rs" ,rust-cairo-rs-0.17)
        ("rust-gdk4" ,rust-gdk4-0.6)
        ("rust-glib" ,rust-glib-0.17)
        ("rust-graphene-rs" ,rust-graphene-rs-0.17)
        ("rust-gsk4-sys" ,rust-gsk4-sys-0.6)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-pango" ,rust-pango-0.17))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings of the GSK 4 library")
    (description "Rust bindings of the GSK 4 library")
    (license license:expat)))

(define-public rust-graphene-sys-0.17
  (package
    (name "rust-graphene-sys")
    (version "0.17.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "graphene-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ybsw0b51dsslln1ign799zn374fcz1nzv4g190nb5cdka2a906g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-glib-sys" ,rust-glib-sys-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-pkg-config" ,rust-pkg-config-0.3)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libgraphene-1.0")
    (description "FFI bindings to libgraphene-1.0")
    (license license:expat)))

(define-public rust-graphene-rs-0.17
  (package
    (name "rust-graphene-rs")
    (version "0.17.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "graphene-rs" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0mk2nkhs0cad45k0177z5h5d9w19qfv7aiwxz71dzr5hbdb13kr1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-glib" ,rust-glib-0.17)
        ("rust-graphene-sys" ,rust-graphene-sys-0.17)
        ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the Graphene library")
    (description "Rust bindings for the Graphene library")
    (license license:expat)))

(define-public rust-pango-0.17
  (package
    (name "rust-pango")
    (version "0.17.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "pango" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0dqdfzavw426ygqq2298fara29yygy79lddkmw4447l85aw81hjj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-gio" ,rust-gio-0.17)
        ("rust-glib" ,rust-glib-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-once-cell" ,rust-once-cell-1)
        ("rust-pango-sys" ,rust-pango-sys-0.17))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the Pango library")
    (description "Rust bindings for the Pango library")
    (license license:expat)))

(define-public rust-pango-sys-0.17
  (package
    (name "rust-pango-sys")
    (version "0.17.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "pango-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1s2xc94xwm3b6wzqh5pj6jkjml1cs070plrl8z1bapjjnpqd14s2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-glib-sys" ,rust-glib-sys-0.17)
        ("rust-gobject-sys" ,rust-gobject-sys-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "http://gtk-rs.org/")
    (synopsis "FFI bindings to libpango-1.0")
    (description "FFI bindings to libpango-1.0")
    (license license:expat)))

(define-public rust-gdk4-sys-0.6
  (package
    (name "rust-gdk4-sys")
    (version "0.6.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gdk4-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0r7dm9vyzg2xlzdgxqa190gd1403mhw4q09x754rq24cc2hjmj8v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-cairo-sys-rs" ,rust-cairo-sys-rs-0.17)
        ("rust-gdk-pixbuf-sys" ,rust-gdk-pixbuf-sys-0.17)
        ("rust-gio-sys" ,rust-gio-sys-0.17)
        ("rust-glib-sys" ,rust-glib-sys-0.17)
        ("rust-gobject-sys" ,rust-gobject-sys-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-pango-sys" ,rust-pango-sys-0.17)
        ("rust-pkg-config" ,rust-pkg-config-0.3)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "http://gtk-rs.org/")
    (synopsis "FFI bindings of GDK 4")
    (description "FFI bindings of GDK 4")
    (license license:expat)))

(define-public rust-gdk4-0.6
  (package
    (name "rust-gdk4")
    (version "0.6.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gdk4" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1zri4z8nxsp88mvk8vhk6xqpc4g1l69zi9w1z3fkwvm211jgkay3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-cairo-rs" ,rust-cairo-rs-0.17)
        ("rust-gdk-pixbuf" ,rust-gdk-pixbuf-0.17)
        ("rust-gdk4-sys" ,rust-gdk4-sys-0.6)
        ("rust-gio" ,rust-gio-0.17)
        ("rust-glib" ,rust-glib-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-pango" ,rust-pango-0.17))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings of the GDK 4 library")
    (description "Rust bindings of the GDK 4 library")
    (license license:expat)))

(define-public rust-gdk-pixbuf-sys-0.17
  (package
    (name "rust-gdk-pixbuf-sys")
    (version "0.17.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gdk-pixbuf-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0fqy77sb5zrqjf0cjgllxpaqn0v3l595d4nkfy9djjgd8hmvshbv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-gio-sys" ,rust-gio-sys-0.17)
        ("rust-glib-sys" ,rust-glib-sys-0.17)
        ("rust-gobject-sys" ,rust-gobject-sys-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "http://gtk-rs.org/")
    (synopsis "FFI bindings to libgdk_pixbuf-2.0")
    (description "FFI bindings to libgdk_pixbuf-2.0")
    (license license:expat)))

(define-public rust-gdk-pixbuf-0.17
  (package
    (name "rust-gdk-pixbuf")
    (version "0.17.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gdk-pixbuf" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1gsrgxnz3mgi20r6axm6qnfq58qdh3chgl85k0yvs1xlqvhgn8xh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-gdk-pixbuf-sys" ,rust-gdk-pixbuf-sys-0.17)
        ("rust-gio" ,rust-gio-0.17)
        ("rust-glib" ,rust-glib-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-once-cell" ,rust-once-cell-1))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the GdkPixbuf library")
    (description "Rust bindings for the GdkPixbuf library")
    (license license:expat)))

(define-public rust-freetype-sys-0.17
  (package
    (name "rust-freetype-sys")
    (version "0.17.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "freetype-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "127z6hbsfhsw0fg110zy9s65fzald0cvwbxmhk1vxmmsdk54hcb4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-cc" ,rust-cc-1)
        ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/PistonDevelopers/freetype-sys")
    (synopsis "Low level binding for FreeType font library")
    (description "Low level binding for FreeType font library")
    (license license:expat)))

(define-public rust-freetype-rs-0.32
  (package
    (name "rust-freetype-rs")
    (version "0.32.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "freetype-rs" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1q54jimjgzwdb3xsp7rsvdmp6w54cak7bvc379mdabc2ciz3776m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-freetype-sys" ,rust-freetype-sys-0.17)
        ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/PistonDevelopers/freetype-rs")
    (synopsis "Bindings for FreeType font library")
    (description "Bindings for FreeType font library")
    (license license:expat)))

(define-public rust-cairo-sys-rs-0.17
  (package
    (name "rust-cairo-sys-rs")
    (version "0.17.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "cairo-sys-rs" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0kjrcfsgp397a4kqfnsr4ssimqpm4j8jdvjy30zybr9h3nh84lzm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-glib-sys" ,rust-glib-sys-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-system-deps" ,rust-system-deps-6)
        ("rust-winapi" ,rust-winapi-0.3)
        ("rust-x11" ,rust-x11-2))))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libcairo")
    (description "FFI bindings to libcairo")
    (license license:expat)))

(define-public rust-cairo-rs-0.17
  (package
    (name "rust-cairo-rs")
    (version "0.17.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "cairo-rs" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0wg8n0yz8p71db4iznp7949xzx92vmzgbhdd51lj5wcasksm9bx8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-cairo-sys-rs" ,rust-cairo-sys-rs-0.17)
        ("rust-freetype-rs" ,rust-freetype-rs-0.32)
        ("rust-glib" ,rust-glib-0.17)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-once-cell" ,rust-once-cell-1)
        ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the Cairo library")
    (description "Rust bindings for the Cairo library")
    (license license:expat)))

(define-public rust-gtk4-0.6
  (package
    (name "rust-gtk4")
    (version "0.6.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gtk4" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "12y8ck3y555mvv65lwm7l19f23wycq68ngwql0afyp6p9jh352mj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:tests? #f
       #:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-cairo-rs" ,rust-cairo-rs-0.17)
        ("rust-field-offset" ,rust-field-offset-0.3)
        ("rust-futures-channel" ,rust-futures-channel-0.3)
        ("rust-gdk-pixbuf" ,rust-gdk-pixbuf-0.17)
        ("rust-gdk4" ,rust-gdk4-0.6)
        ("rust-gio" ,rust-gio-0.17)
        ("rust-glib" ,rust-glib-0.17)
        ("rust-graphene-rs" ,rust-graphene-rs-0.17)
        ("rust-gsk4" ,rust-gsk4-0.6)
        ("rust-gtk4-macros" ,rust-gtk4-macros-0.6)
        ("rust-gtk4-sys" ,rust-gtk4-sys-0.6)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-once-cell" ,rust-once-cell-1)
        ("rust-pango" ,rust-pango-0.17))
       #:cargo-development-inputs
       (("rust-gir-format-check" ,rust-gir-format-check-0.1))))
    (native-inputs
     (list pkg-config))
    (inputs
     (list glib pango gdk-pixbuf graphene gtk))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings of the GTK 4 library")
    (description "Rust bindings of the GTK 4 library")
    (license license:expat)))

(define-public rust-pipewire-sys-0.6
  (package
    (name "rust-pipewire-sys")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pipewire-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "08r19mahd0cjg23z5pnvph599syxs0f2dh7x48wsmdkzvgp90lm9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bindgen" ,rust-bindgen-0.64)
        ("rust-libspa-sys" ,rust-libspa-sys-0.6)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "https://pipewire.org")
    (synopsis "Rust FFI bindings for PipeWire")
    (description "Rust FFI bindings for PipeWire")
    (license license:expat)))

(define-public rust-libspa-sys-0.6
  (package
    (name "rust-libspa-sys")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libspa-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0yjcadwv8zas8rk0kin57i7148lfcblilicdm1ydyd15yn45pkvr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bindgen" ,rust-bindgen-0.64)
        ("rust-cc" ,rust-cc-1)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "https://pipewire.org")
    (synopsis "Rust FFI bindings for libspa")
    (description "Rust FFI bindings for libspa")
    (license license:expat)))

(define-public rust-libspa-0.6
  (package
    (name "rust-libspa")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libspa" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0zfpjzcn6zbf0h1k7ns2fv73x4jm296w1z9ssghpw7rx1jsznzb6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-bitflags" ,rust-bitflags-1)
        ("rust-cc" ,rust-cc-1)
        ("rust-cookie-factory" ,rust-cookie-factory-0.3)
        ("rust-errno" ,rust-errno-0.3)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-libspa-sys" ,rust-libspa-sys-0.6)
        ("rust-nom" ,rust-nom-7)
        ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "https://pipewire.org")
    (synopsis "Rust bindings for libspa")
    (description "Rust bindings for libspa")
    (license license:expat)))

(define-public rust-windows-x86-64-msvc-0.48
  (package
    (name "rust-windows-x86-64-msvc")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_x86_64_msvc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "12ipr1knzj2rwjygyllfi5mkd0ihnbi3r61gag5n2jgyk5bmyl8s"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnullvm-0.48
  (package
    (name "rust-windows-x86-64-gnullvm")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_x86_64_gnullvm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0lxryz3ysx0145bf3i38jkr7f9nxiym8p3syklp8f20yyk0xp5kq"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnu-0.48
  (package
    (name "rust-windows-x86-64-gnu")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_x86_64_gnu" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1cblz5m6a8q6ha09bz4lz233dnq5sw2hpra06k9cna3n3xk8laya"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-msvc-0.48
  (package
    (name "rust-windows-i686-msvc")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_i686_msvc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "004fkyqv3if178xx9ksqc4qqv8sz8n72mpczsr2vy8ffckiwchj5"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-gnu-0.48
  (package
    (name "rust-windows-i686-gnu")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_i686_gnu" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0hd2v9kp8fss0rzl83wzhw0s5z8q1b4875m6s1phv0yvlxi1jak2"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-msvc-0.48
  (package
    (name "rust-windows-aarch64-msvc")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_aarch64_msvc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1wvwipchhywcjaw73h998vzachf668fpqccbhrxzrz5xszh2gvxj"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-gnullvm-0.48
  (package
    (name "rust-windows-aarch64-gnullvm")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows_aarch64_gnullvm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1g71yxi61c410pwzq05ld7si4p9hyx6lf5fkw21sinvr3cp5gbli"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-targets-0.48
  (package
    (name "rust-windows-targets")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-targets" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1mfzg94w0c8h4ya9sva7rra77f3iy1712af9b6bwg03wrpqbc7kv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-windows-aarch64-gnullvm" ,rust-windows-aarch64-gnullvm-0.48)
        ("rust-windows-aarch64-msvc" ,rust-windows-aarch64-msvc-0.48)
        ("rust-windows-i686-gnu" ,rust-windows-i686-gnu-0.48)
        ("rust-windows-i686-msvc" ,rust-windows-i686-msvc-0.48)
        ("rust-windows-x86-64-gnu" ,rust-windows-x86-64-gnu-0.48)
        ("rust-windows-x86-64-gnullvm" ,rust-windows-x86-64-gnullvm-0.48)
        ("rust-windows-x86-64-msvc" ,rust-windows-x86-64-msvc-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import libs for Windows")
    (description "Import libs for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-sys-0.48
  (package
    (name "rust-windows-sys")
    (version "0.48.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "windows-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1aan23v5gs7gya1lc46hqn9mdh8yph3fhxmhxlw36pn6pqc28zb7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-windows-targets" ,rust-windows-targets-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-errno-0.3
  (package
    (name "rust-errno")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "errno" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0fp7qy6fwagrnmi45msqnl01vksqwdb2qbbv60n9cz7rf0xfrksb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-errno-dragonfly" ,rust-errno-dragonfly-0.1)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/lambda-fairy/rust-errno")
    (synopsis "Cross-platform interface to the `errno` variable.")
    (description "Cross-platform interface to the `errno` variable.")
    (license (list license:expat license:asl2.0))))

(define-public rust-pipewire-0.6
  (package
    (name "rust-pipewire")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pipewire" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1jsw2d5ycpyhghp0icfjf642f623znk2zmvcdvl5p1abm2j808fw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-anyhow" ,rust-anyhow-1)
        ("rust-bitflags" ,rust-bitflags-1)
        ("rust-errno" ,rust-errno-0.3)
        ("rust-libc" ,rust-libc-0.2)
        ("rust-libspa" ,rust-libspa-0.6)
        ("rust-libspa-sys" ,rust-libspa-sys-0.6)
        ("rust-nix" ,rust-nix-0.26)
        ("rust-once-cell" ,rust-once-cell-1)
        ("rust-pipewire-sys" ,rust-pipewire-sys-0.6)
        ("rust-thiserror" ,rust-thiserror-1))
       #:cargo-development-inputs
       (("rust-once-cell" ,rust-once-cell-1)
        ("rust-structopt" ,rust-structopt-0.3))))
    (native-inputs
     (list llvm-14))
    (home-page "https://pipewire.org")
    (synopsis "Rust bindings for PipeWire")
    (description "Rust bindings for PipeWire")
    (license license:expat)))

rust-pipewire-0.6
