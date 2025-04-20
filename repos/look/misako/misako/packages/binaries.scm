(define-module (misako packages binaries)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages wine)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages music)
  #:use-module (gnu packages kerberos)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages node)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages video)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (nonguix build-system chromium-binary)
  #:use-module (ice-9 match)
  #:export (vesktop
            path-of-building-bin
            libdeep-filter-ladspa-bin))

(define path-of-building-bin
  (package
    (name "path-of-building-bin")
    (version "2.52.3")
    (source
      (origin
        (method url-fetch/zipbomb)
        (uri
          (string-append "https://github.com/PathOfBuildingCommunity/PathOfBuilding"
                        "/releases/download/v" version
                        "/PathOfBuildingCommunity-Portable.zip"))
        (sha256
          (base32 "15acf0k71lrfcbv7m9bkghsj84wv53s35i809w0i2iazk7ykv06a"))))
    (build-system copy-build-system)
    (arguments
      (list #:install-plan
            #~'(("." "opt/pob/"))
            #:phases
            #~(modify-phases %standard-phases
                (add-after 'install 'make-bin
                  (lambda _
                    (let* ((pob (string-append #$output "/opt/pob/pob"))
                           (bin (string-append #$output "/bin/pob")))
                      (with-output-to-file pob
                         (lambda _
                           (define (line . args)
                             (display (apply string-append args)) (newline))
                           (define pob "$HOME/.local/share/pob")
                           (line "#!/bin/sh")
                           (line "if [ ! -d \"$HOME/.local/share/pob\" ]; then")
                           (line "    mkdir -p \"" pob "\"")
                           (line (string-append "    cp -r " #$output "/opt/pob/* \"" pob "\""))
                           (line "fi")
                           (line (string-append "cd " pob))
                           (line (string-append #$wine64-staging
                                                "/bin/wine Path\\ of\\ Building.exe"))))
                      (chmod pob #o755)
                      (mkdir-p (dirname bin))
                      (symlink pob bin)))))))
    (native-inputs (list unzip))
    (inputs (list wine64-staging))
    (home-page "https://pathofbuilding.community/")
    (synopsis "Offline build planner for Path of Exile")
    (description "Path of Building Community is a fork of the original Path of
Building by Openarl. It is now actively maintained by Path of Exile community
members. Features not originally present have been added, new mechanics are
getting supported regularly, and any work on the original is integrated as
well.")
    (license license:expat)))

(define libdeep-filter-ladspa-bin
  (package
    (name "libdeep-filter-ladspa-bin")
    (version "0.5.6")
    (source
      (origin
        (method url-fetch)
        (uri
          (string-append "https://github.com/Rikorose/DeepFilterNet/releases/download/v"
                         version "/libdeep_filter_ladspa-"
                         version "-x86_64-unknown-linux-gnu.so"))
        (sha256
          (base32 "0di2bqrjn9a8h8fbijmma81db5smfh728sl299h8klqi55f218rc"))))
    (build-system copy-build-system)
    (arguments
      (list #:install-plan
            #~'(("libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so" "lib/ladspa/libdeep_filter_ladspa.so"))
            #:phases
            #~(modify-phases %standard-phases
                (add-after 'install 'fix-permission
                  (lambda _
                    (for-each (lambda (f)
                                (chmod f #o777))
                              (find-files (string-append #$output "/lib")))))
                (add-after 'fix-permission 'patch-elf
                  (lambda* (#:key inputs #:allow-other-keys)
                    (let ((ld.so (string-append #$(this-package-input "glibc")
                                                #$(glibc-dynamic-linker)))
                          (rpath (string-join
                                   (map
                                     (lambda (input)
                                       (string-append (cdr input) "/lib"))
                                     inputs)
                                   ":")))
                      (define (patch-elf file)
                        (format #t "Patching ~a ..." file)
                        (unless (string-contains file ".so")
                          (invoke "patchelf" "--set-interpreter" ld.so file))
                        (invoke "patchelf" "--set-rpath" rpath file)
                        (display " done\n"))
                      (for-each
                        (lambda (binary)
                          (patch-elf binary))
                        (find-files (string-append #$output "/lib") ".*\\.so.*"))))))))
    (inputs (list glibc gcc-toolchain))
    (native-inputs (list patchelf))
    (home-page "https://github.com/Rikorose/DeepFilterNet")
    (synopsis "Noise supression using deep filtering")
    (description "A Low Complexity Speech Enhancement Framework for Full-Band Audio (48kHz) using on Deep Filtering (LASPDA).")
    (license license:expat)))

(define vesktop
  (package
    (name "vesktop")
    (version "1.5.6")
    (source
      (origin
        (method url-fetch)
        (uri
          (string-append "https://github.com/Vencord/Vesktop/releases/download/"
                         "v" version "/" name "-" version ".tar.gz"))
        (sha256
          (base32 "0qfks7gwqn5hcwkwiq8lf4jw72yv2jklvxan8a2814jbzfswn1c1"))))
    (build-system chromium-binary-build-system)
    (arguments
      (list
        #:wrapper-plan
        #~`("vesktop"
            "chrome-sandbox"
            "chrome_crashpad_handler"
            "libEGL.so"
            "libffmpeg.so"
            "libGLESv2.so"
            "libvk_swiftshader.so"
            "libvulkan.so.1")
        #:patchelf-plan
        #~`(("vesktop") ("chrome_crashpad_handler") ("chrome-sandbox"))
        #:install-plan
        #~`(("." "opt/vesktop")
            ("vesktop" "bin/vesktop"))
        #:native-inputs `(("alsa-lib" ,alsa-lib)
                          ("atk" ,atk)
                          ("at-spi2-atk" ,at-spi2-atk)
                          ("at-spi2-core" ,at-spi2-core)
                          ("bash-minimal" ,bash-minimal)
                          ("cairo" ,cairo)
                          ("cups" ,cups)
                          ("dbus" ,dbus)
                          ("eudev" ,eudev)
                          ("expat" ,expat)
                          ("fontconfig" ,fontconfig)
                          ("freetype" ,freetype)
                          ("gcc:lib" ,gcc-13 "lib")
                          ("glib" ,glib)
                          ("gtk+" ,gtk+)
                          ("libdrm" ,libdrm)
                          ("libnotify" ,libnotify)
                          ("librsvg" ,librsvg)
                          ("libsecret" ,libsecret)
                          ("libx11" ,libx11)
                          ("libxcb" ,libxcb)
                          ("libxcomposite" ,libxcomposite)
                          ("libxcursor" ,libxcursor)
                          ("libxdamage" ,libxdamage)
                          ("libxext" ,libxext)
                          ("libxfixes" ,libxfixes)
                          ("libxi" ,libxi)
                          ("libxkbcommon" ,libxkbcommon)
                          ("libxkbfile" ,libxkbfile)
                          ("libxrandr" ,libxrandr)
                          ("libxrender" ,libxrender)
                          ("libxshmfence" ,libxshmfence)
                          ("libxtst" ,libxtst)
                          ("mesa" ,mesa)
                          ("mit-krb5" ,mit-krb5)
                          ("nspr" ,nspr)
                          ("nss" ,nss)
                          ("pango" ,pango)
                          ("pulseaudio" ,pulseaudio)
                          ("sqlcipher" ,sqlcipher)
                          ("xcb-util" ,xcb-util)
                          ("xcb-util-image" ,xcb-util-image)
                          ("xcb-util-keysyms" ,xcb-util-keysyms)
                          ("xcb-util-renderutil" ,xcb-util-renderutil)
                          ("xcb-util-wm" ,xcb-util-wm)
                          ("zlib" ,zlib)
                          ,@(standard-packages))
        #:phases
        #~(modify-phases %standard-phases
            (add-before 'install-wrapper 'wrap-where-patchelf-does-not-work
              (lambda _
                (let* ((bin (string-append #$output "/opt/vesktop/vesktop"))
                       (wrapper (string-append #$output "/bin/vesktop")))
                  (mkdir-p (dirname wrapper))
                  (make-wrapper wrapper bin
                    `("LD_LIBRARY_PATH" prefix (,(string-append #$output "/opt/vesktop")))))))
            (add-after 'install-wrapper 'add-wayland-flag
              (lambda _
                (substitute* (string-append #$output "/bin/vesktop")
                  (("(\\.vesktop-real\")" v)
                   (string-join
                     (list v
                           "${WAYLAND_DISPLAY:+"
                           "--enable-features=UseOzonePlatform"
                           "--ozone-platform-hint=auto"
                           ; "--ozone-platform=wayland"
                           "--enable-features=WebRTCPipeWireCapturer"
                           "--enable-features=VaapiVideoDecoder"
                           "--use-angle=vulkan"
                           "--ignore-gpu-blocklist"
                           "--enable-zero-copy"
                           "--disable-gpu-compositing"
                           "--enable-gpu-rasterization"
                           "}")))))))))
    (inputs
      (list ffmpeg
            gdk-pixbuf
            libappindicator
            libdbusmenu
            libglvnd
            libxscrnsaver
            util-linux
            wayland
            gzip
            libsm
            node
            pipewire
            pulseaudio
            unzip
            wget
            xdg-utils))
    (synopsis "Vesktop is a custom Discord App aiming to give you better performance and improve linux support")
    (description "Vesktop main features are:
@itemize
  @item @command{Vencord} preinstalled
  @item Much more lightweight and faster than the official Discord app
  @item @command{Linux Screenshare} with sound & wayland
  @item Much better privacy, since Discord has no access to your system
@end itemize")
    (home-page "https://github.com/Vencord/Vesktop")
    (license (list license:gpl3))))
