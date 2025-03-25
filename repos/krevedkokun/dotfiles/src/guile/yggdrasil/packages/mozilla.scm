(define-module (yggdrasil packages mozilla)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pciutils)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (nongnu packages mozilla)
  #:use-module (nongnu packages video))

(define %librewolf-build-id "20240203000000")

(define-public librewolf
  (package/inherit firefox
    (name "librewolf")
    (version "122.0-1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://gitlab.com/api/v4/projects/32320088/packages/generic/librewolf-source/"
             version "/librewolf-" version ".source.tar.gz"))
       (sha256
        (base32 "180896pria4sb93dkpqfy65fzkj9q74q8jr2n7459xhhq1mrzc9f"))))
    (arguments
     (substitute-keyword-arguments (package-arguments firefox)
       ((#:modules modules)
        `((srfi srfi-1)
          ,@modules))
       ((#:configure-flags flags)
        #~(cons*
           "--with-app-name=librewolf"
           "--with-app-basename=LibreWolf"
           "--with-branding=browser/branding/librewolf"
           "--with-distribution-id=io.gitlab.librewolf-community"
           "--with-unsigned-addon-scopes=app,system"
           "--allow-addon-sideload"
           "--enable-default-toolkit=cairo-gtk3-wayland-only"
           (lset-difference equal? #$flags
                            '("--with-distribution-id=org.nonguix"
                              "--disable-official-branding"))))
       ((#:phases phases)
        #~(modify-phases #$phases
            (replace 'set-build-id
              (lambda _
                (setenv "MOZ_BUILD_DATE" #$%librewolf-build-id)))
            (replace 'wrap-program
              (lambda* (#:key inputs #:allow-other-keys)
                (define (runpath-of lib)
                  (call-with-input-file lib
                    (compose elf-dynamic-info-runpath
                             elf-dynamic-info
                             parse-elf
                             get-bytevector-all)))
                (define (runpaths-of-input label)
                  (let* ((dir (string-append (assoc-ref inputs label) "/lib"))
                         (libs (find-files dir "\\.so$")))
                    (append-map runpath-of libs)))
                (let* ((lib (string-append #$output "/lib"))
                       (gtk #$(this-package-input "gtk+"))
                       (gtk-share (string-append gtk "/share"))
                       (ld-libs (append
                                 '("/run/current-system/profile/lib/dri/")
                                 (map (cut string-append <> "/")
                                      (delete-duplicates
                                       (append-map runpaths-of-input '("mesa" "ffmpeg"))))
                                 '#$(map (lambda (label)
                                           (file-append (this-package-input label) "/lib"))
                                         '("eudev" "libva" "libnotify" "cups"
                                           "pciutils" "mit-krb5" "pulseaudio"
                                           "pipewire" "gmmlib")))))
                  (wrap-program (car (find-files lib "^librewolf$"))
                    `("XDG_DATA_DIRS" prefix (,gtk-share))
                    `("LD_LIBRARY_PATH" prefix ,ld-libs)
                    `("MOZ_LEGACY_PROFILES" = ("1"))
                    `("MOZ_ALLOW_DOWNGRADE" = ("1"))))))
            (replace 'install-desktop-entry
              (lambda _
                (let* ((desktop-file "taskcluster/docker/firefox-snap/firefox.desktop")
                       (applications (string-append #$output "/share/applications")))
                  (substitute* desktop-file
                    (("^Exec=firefox") (string-append "Exec=" #$output "/bin/librewolf"))
                    (("Firefox") "LibreWolf")
                    (("Icon=.*") "Icon=librewolf\n")
                    (("NewWindow") "new-window")
                    (("NewPrivateWindow") "new-private-window")
                    (("StartupNotify=true")
                     "StartupNotify=true\nStartupWMClass=Navigator"))
                  (mkdir-p applications)
                  (copy-file desktop-file (string-append applications "/librewolf.desktop")))))))))
    (inputs
     (modify-inputs (package-inputs firefox)
       (delete "libxcomposite"
               "libxft"
               "libxinerama"
               "libxscrnsaver"
               "libxt"
               "gtk+")
       (prepend gtk+ gmmlib pciutils)))))
librewolf
