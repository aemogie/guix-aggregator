;; This is an operating system configuration for a bootable GParted image.
;; Modify it as you see fit and rebuild it by running:
;;
;;   guix system image /path/to/gparted.scm
;;

(define-module (gparted))
(use-modules (gnu)
             (guix)
             (guix transformations)
             (srfi srfi-1)
             (guix build-system trivial))
(use-service-modules
  admin
  xorg)
(use-package-modules
  compression
  disk
  fontutils
  gl
  gtk
  linux
  llvm
  package-management
  wm
  xorg)

;;

(define gtk+-minimal
  (package/inherit gtk+
    (arguments
     (substitute-keyword-arguments (package-arguments gtk+)
       ;; The tests need more of the inputs that we've stripped
       ;; away in order to pass. Skip the tests for now.
       ((#:tests? _ #t) #f)
       ((#:configure-flags _ #~'())
        #~(list "-Dwayland_backend=false"
                "-Dprint_backends=file"
                "-Dintrospection=false"))
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install 'remove-localizations
              (lambda* (#:key outputs #:allow-other-keys)
                (delete-file-recursively
                  (string-append (assoc-ref outputs "out")
                                 "/share/locale"))))))))
    (propagated-inputs
     (modify-inputs (package-propagated-inputs gtk+)
                    (prepend gdk-pixbuf)
                    (delete "fontconfig"
                            "freetype"
                            "librsvg"   ; gdk-pixbuf
                            "libcloudproviders-minimal"
                            "libx11"
                            "libxcomposite"
                            "libxcursor"
                            "libxdamage"
                            "libxext"
                            "libxfixes"
                            "libxinerama"
                            "libxkbcommon"
                            "libxrender"
                            "mesa"
                            "wayland"
                            "wayland-protocols")))
    (inputs
     (modify-inputs (package-inputs gtk+)
                    (delete "colord-minimal"
                            "cups"
                            "graphene"
                            "iso-codes"
                            "harfbuzz")))))

(define harfbuzz-minimal
  (package/inherit harfbuzz
    (outputs (cons "doc" (package-outputs harfbuzz)))
    (arguments
     (substitute-keyword-arguments (package-arguments harfbuzz)
       ((#:configure-flags cf ''())
        `(cons* "--with-icu=no"
                ;"--disable-introspection"  ; causes pango to fail
                "--disable-gtk-doc-html"
                (string-append "--with-html-dir="
                               (assoc-ref %outputs "doc")
                               "/share/gtk-doc/html")
                (delete "--with-graphite2" ,cf)))))
    (propagated-inputs
     (modify-inputs (package-propagated-inputs harfbuzz)
                    (delete "graphite2" "icu4c")))))

;; freetype-config embeds a reference to pkg-config.
(define freetype-minimal
  (package
    (inherit freetype)
    (arguments
     (substitute-keyword-arguments (package-arguments freetype)
       ((#:configure-flags _)
        ;`(list "--disable-static"))))))
        `(list "--disable-freetype-config"))))))

(define btrfs-progs-minimal
  (package
    (inherit btrfs-progs)
    (arguments
     (substitute-keyword-arguments (package-arguments btrfs-progs)
       ((#:configure-flags cf #~'())
        ;; texlive-bin FTBFS with the package changes.
        #~(cons* "--disable-documentation" #$cf))))
    (native-inputs
     (modify-inputs (package-native-inputs btrfs-progs)
                    (delete "python-sphinx")))))

;; Is it worth it? This is also pulled in by e2fsprogs which comes with the
;; initramfs, meaning we effectively have two copies in the OS closure.
(define util-linux-minimal
  (package/inherit util-linux
    (arguments
     (substitute-keyword-arguments (package-arguments util-linux)
       ((#:phases phases '%standard-phases)
        `(modify-phases ,phases
           (add-after 'install 'remove-localizations
             (lambda* (#:key outputs #:allow-other-keys)
               (delete-file-recursively
                 ;; ~75% of the "lib" output.
                 (string-append (assoc-ref outputs "lib")
                                "/share/locale"))))))))))

(define (remove-static-libraries pkg)
  (package/inherit pkg
    (arguments
     (substitute-keyword-arguments (package-arguments pkg)
       ((#:phases phases '%standard-phases)
        `(modify-phases ,phases
           (add-after 'install 'delete-static-libraries
             (lambda* (#:key outputs #:allow-other-keys)
               (for-each delete-file
                         (find-files
                           (string-append (assoc-ref outputs "out") "/lib")
                           "\\.a$"))))))))))

(define libelf-smaller
  (remove-static-libraries (specification->package "libelf")))

(define elfutils-smaller
  (remove-static-libraries (specification->package "elfutils")))

(define readline-smaller
  (remove-static-libraries (specification->package "readline")))

(define parted-minimal
  (package
    (inherit parted)
    (arguments
     (substitute-keyword-arguments (package-arguments parted)
       ((#:configure-flags cf #~'())
        #~(cons* "--without-readline"
                 "--disable-static"
                 #$cf))))
    (inputs (modify-inputs (package-inputs parted)
                           (delete "readline")))))

(define mesa-smaller
  (package/inherit mesa
    (arguments
     (substitute-keyword-arguments (package-arguments mesa)
       ((#:modules modules)
        `((ice-9 regex)
          (srfi srfi-26)
          ,@modules))
       ((#:build-type _) "minsize") ; decreases the size by ~30%.
       ((#:configure-flags cf #~'())
        #~(append
           (remove
             (cut string-match
                  "-D(platforms|vulkan-(drivers|layers)|gles2|gbm|shared-glapi)=.*" <>)
             #$cf)

           ;; This has to go last so we can disable vulkan.
           (list "-Dplatforms=x11"
                 "-Dvulkan-drivers=")))
       ((#:phases phases)
        #~(modify-phases #$phases
            (delete 'set-layer-path-in-manifests)))))
    (inputs
     (modify-inputs (package-inputs mesa)
                    ;; TODO: Can this be taken care of with use-minimized-inputs?
                    ;(replace "llvm" llvm-minimal)
                    (delete "wayland" "wayland-protocols")))))

;; We could use a newer version of llvm, but this is the version mesa
;; is currently built against, so it has the most testing in Guix.
(define llvm-minimal
  (package/inherit llvm-for-mesa
    ;; If we can separate out the include directory we'd save another 21MB.
    (outputs (list "out"))
    (version (package-version llvm-for-mesa))
    (arguments
     (substitute-keyword-arguments (package-arguments llvm-for-mesa)
       ((#:build-type _) "MinSizeRel") ; decreases the size by ~25%
       ((#:configure-flags cf ''())
        ;; AMDGPU is needed by the vulkan drivers.
        `(list ,(string-append "-DLLVM_TARGETS_TO_BUILD="
                                (system->llvm-target) ";AMDGPU")
               "-DLLVM_BUILD_TOOLS=NO"
               "-DLLVM_BUILD_LLVM_DYLIB=YES"
               "-DLLVM_LINK_LLVM_DYLIB=YES"))))))

(define use-minimized-inputs
  (package-input-rewriting/spec
    `(;("elfutils" . ,(const elfutils-smaller))
      ;("freetype" . ,(const freetype-minimal))
      ("gtk+" . ,(const gtk+-minimal))
      ;("harfbuzz" . ,(const harfbuzz-minimal))
      ;("libelf" . ,(const libelf-smaller))
      ;("llvm" . ,(const llvm-minimal))
      ;("mesa" . ,(const mesa-smaller))             ; breaks xorg-server tests?
      ;("parted" . ,(const parted-minimal))
      ;("readline" . ,(const readline-smaller))
      ;("util-linux" . ,(const util-linux-minimal))
      )))

;;

;; This needs to be rebuilt, not just substituted.
(define fluxbox-custom
  (let ((base (use-minimized-inputs fluxbox)))
    (package
      (inherit base)
      (arguments
       (substitute-keyword-arguments (package-arguments base)
         ((#:phases phases)
          `(modify-phases ,phases
             (delete 'install-vim-files)
             (add-after 'install 'adjust-fluxbox-menu
               (lambda* (#:key outputs #:allow-other-keys)
                (let ((out (assoc-ref %outputs "out")))
                  (substitute* (string-append out "/share/fluxbox/menu")
                    (("\\(firefox.*") "(gparted) {gparted}\n"))))))))))))

(define gparted-custom
  (package
    (inherit (use-minimized-inputs gparted))
    (arguments
     (substitute-keyword-arguments (package-arguments gparted)
       ((#:configure-flags cf ''())
        `(cons* "--enable-libparted-dmraid" ,cf))))))

(define* (minimized-package pkg)
  (package
    (inherit (use-minimized-inputs pkg))))

(define fuse-minimized
  (minimized-package fuse))

(define lvm2-minimized
  (minimized-package lvm2))

(define mdadm-minimized
  (minimized-package mdadm))

;;

(operating-system
  (host-name "gnu")
  (timezone "Etc/UTC")
  (locale "en_US.utf8")
  (keyboard-layout (keyboard-layout "us" "altgr-intl"))

  ;; Label for the GRUB boot menu.
  (label (string-append "GNU Guix " (package-version guix) " with GParted"))

  (bootloader (bootloader-configuration
               (bootloader
                 (bootloader (inherit grub-bootloader)
                             (package (minimized-package (specification->package "grub")))))
               (targets '("/dev/vda"))
               (terminal-outputs '(console))))
  (file-systems (cons (file-system
                        (device (file-system-label "root"))
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))
  (firmware '())
  (locale-libcs (list glibc))

  (users %base-user-accounts)

  (packages
    (append
      (map use-minimized-inputs
         (append
           (map specification->package
                (list
                  "neofetch"           ; bash-minimal

                  "xterm"              ; actually, a lot

                  "cryptsetup"         ; libgcrypt, util-linux:lib, eudev, json-c, argon2, libgpg-error, popt, lvm2
                  "lvm2"               ; lvm2-static has a larger size than lvm2 with the same closure
                  "mdadm"              ; eudev

                  ;"bcachefs-tools"
                  ;"btrfs-progs"        ; zstd:lib, e2fsprogs, eudev, zlib, lzo
                  "dosfstools"         ; only glibc, gcc:lib
                  "mtools"             ; needed by fat16/fat32; glibc, gcc:lib, bash-minimal
                  ;; Already included from the filesystem type.
                  ;"e2fsprogs"          ; util-linux:lib
                  "exfatprogs"         ; only glibc, gcc:lib
                  "f2fs-tools"         ; util-linux:lib
                  "jfsutils"           ; util-linux:lib
                  "nilfs-utils"        ; util-linux:lib
                  "ntfs-3g"            ; fuse-2
                  "udftools"           ; only glibc, gcc:lib
                  "xfsprogs"))
           (list btrfs-progs-minimal
                 gparted-custom
                 fluxbox-custom)       ; also a lot :/
           %base-packages-interactive
           %base-packages-linux
           %base-packages-utils))))

  ;; Use a modified list of setuid-programs.
  ;; Are there any we need? We run as root.
  (privileged-programs
    (list
  ;    (setuid-program (program (file-append foo "/bin/foo")))
    ))

  (services
   (append
     (list (service slim-service-type
                    (slim-configuration
                      (slim (minimized-package (specification->package "slim")))
                      (auto-login? #t)
                      (default-user "root")
                      (xorg-configuration
                        (xorg-configuration
                          (keyboard-layout keyboard-layout)))))

           (service special-files-service-type
                    `(("/root/.fluxbox/startup"
                       ,(mixed-text-file
                          "fluxbox-startup"
                          "exec /run/current-system/profile/bin/gparted &\n"
                          "exec /run/current-system/profile/bin/xterm &\n"
                          "exec fluxbox\n")))))

     (remove (lambda (service)
               (let ((type (service-kind service)))
                 (memq type
                       (list
                         guix-service-type          ; not actually needed
                         log-cleanup-service-type
                         nscd-service-type          ; no networking
                         log-rotation-service-type))))
             (modify-services
               %base-services
               (udev-service-type
                 config =>
                 (udev-configuration
                   (udev (minimized-package (specification->package "eudev")))
                   (rules (list fuse-minimized
                                lvm2-minimized
                                mdadm-minimized)))))))))
