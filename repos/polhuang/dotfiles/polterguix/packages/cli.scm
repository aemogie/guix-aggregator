(define-module (polterguix packages cli)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages perl)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system perl)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (nonguix build-system binary))

(define-public asciiquarium
  (package
    (name "asciiquarium")
    (version "1.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/cmatsuoka/asciiquarium")
                    (commit "master")))
              (file-name (git-file-name name version))
              (sha256
               (base32 "09klv6v3y1kp836rwybcyz1jvxd6s9jadx535r0ivgxczvggnwhq"))))
    (build-system perl-build-system)
    (native-inputs
     `(("perl-module-build" ,perl-module-build)))
    (propagated-inputs
     `(("perl-term-animation" ,perl-term-animation)
       ("perl-curses" ,perl-curses)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace 'build
           (lambda* (#:key outputs #:allow-other-keys)
             (chmod "asciiquarium" #o755)))
         (delete 'check)
         (replace 'install
           (lambda* (#:key outputs inputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (lib (assoc-ref inputs "perl-term-animation")))
               (install-file "asciiquarium" bin)
               (wrap-program (string-append bin "/asciiquarium")
                 `("PERL5LIB" ":" prefix
                   (,(string-append lib "/lib/perl5/site_perl"
                                    ":" (assoc-ref inputs "perl-curses") "/lib/perl5/site_perl"))))))))))
    (home-page "http://robobunny.com/projects/asciiquarium")
    (synopsis "Aquarium animation in ASCII art")
    (description "Asciiquarium is an aquarium animation using ASCII art. It requires Term::Animation and Curses modules.")
    (license gpl2+)))

(define-public perl-term-animation
  (package
    (name "perl-term-animation")
    (version "1.0.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/hakonhagland/perl-term-animation")
                    (commit "main")))
              (file-name (git-file-name name version))
              (sha256
               (base32 "0wjydgf6hs4f5a5aaki9jfb55kb3yq5f20fa3vy6n9054s4v0arc"))))
    (build-system perl-build-system)
    (native-inputs
     `(("perl-module-build" ,perl-module-build)))
    (propagated-inputs
     `(("perl-curses" ,perl-curses)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'build 'configure-environment
           (lambda* (#:key outputs inputs #:allow-other-keys)
             (setenv "PERL_MM_OPT" (string-append "INSTALL_BASE=" (assoc-ref outputs "out")))))
         (replace 'build
           (lambda _
             (invoke "make")))
         (replace 'check
           (lambda _
             (invoke "make" "test")))
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (invoke "make" "install"))))))
    (home-page "https://github.com/hakonhagland/perl-term-animation")
    (synopsis "Produce sprite animations using ASCII art")
    (description "This Perl module provides a framework to produce sprite animations using ASCII art. Each ASCII 'sprite' is given one or more frames, and placed into the animation as an 'animation entity'. An animation entity can have a callback routine that controls the position and frame of the entity. The module can also do collision detection between entities.")
    (license perl-license)))

(define-public starship-bin
  (package
    (name "starship-bin")
    (version "1.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/starship/starship/releases/download/v"
             version
             "/starship-x86_64-unknown-linux-gnu.tar.gz"))
       (sha256
        (base32
         "1bjq6y3wfxanahw4rzqxl86kc4j3slrg8dixnhf5hf31yd57yydv"))))
    (build-system binary-build-system)
    (arguments
     `(#:install-plan
       `(("starship" "/bin/"))
       #:patchelf-plan
       `(("starship" ("gcc:lib" "glibc")))
       #:phases
       (modify-phases %standard-phases
         (replace 'unpack
           (lambda* (#:key inputs #:allow-other-keys)
             (invoke "tar" "-xvzf" (assoc-ref inputs "source")))))))
    (inputs
     `(("gcc:lib" ,gcc "lib")
       ("glibc" ,glibc)))
    (native-inputs
     `(("gzip" ,gzip)))
    (synopsis "Starship is the minimal, blazing fast, and extremely customizable prompt for any shell!")
    (description "Starship is the minimal, blazing fast, and extremely customizable prompt for any shell!")
    (home-page "https://github.com/starship/starship")
    (license isc)))
