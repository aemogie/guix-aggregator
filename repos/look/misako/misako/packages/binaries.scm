;; SPDX-FileCopyrightText: 2025 Murilo <murilo@disroot.org>
;;
;; SPDX-License-Identifier: GPL-3.0

(define-module (misako packages binaries)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages kerberos)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages python)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages music)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages video)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages wine)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system qt)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:use-module (radix packages video)
  #:use-module (saayix packages gtk)
  #:use-module (misako packages cuda)
  #:use-module (nongnu packages chromium)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu packages dotnet)
  #:use-module (saayix build-system binary)
  #:use-module (saayix build-system chromium-binary)
  #:export (libdeep-filter-ladspa-bin
            ollama-bin
            opentabletdriver-bin))

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
    (build-system binary-build-system)
    (arguments
      (list #:install-plan
            #~'(("libdeep_filter_ladspa-0.5.6-x86_64-unknown-linux-gnu.so" "lib/ladspa/libdeep_filter_ladspa.so"))
            #:phases
            #~(modify-phases %standard-phases
                (add-after 'install 'fix-permission
                  (lambda _
                    (for-each (lambda (f)
                                (chmod f #o777))
                              (find-files (string-append #$output "/lib"))))))))
    (inputs (list glibc gcc-toolchain))
    (home-page "https://github.com/Rikorose/DeepFilterNet")
    (synopsis "Noise supression using deep filtering")
    (description "A Low Complexity Speech Enhancement Framework for Full-Band Audio (48kHz) using on Deep Filtering (LASPDA).")
    (license license:expat)))

(define-public vesktop
  (package
    (name "vesktop")
    (version "1.6.3")
    (source
      (origin
        (method url-fetch)
        (uri
          (string-append "https://github.com/Vencord/Vesktop/releases/download/"
                         "v" version "/" name "-" version ".tar.gz"))
        (sha256
          (base32 "13msfzk25kvqbxkxs7icgwm6kg1wlrzybwwjivcb43zb9mjm7s75"))))
    (build-system chromium-binary-build-system)
    (arguments
      (list
        #:install-plan
        #~`(("." "opt/vesktop"))
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'patchelf 'install-bin
              (lambda _
                (let* ((wrappee (string-append #$output "/opt/vesktop/vesktop"))
                       (wrapper (string-append #$output "/bin/vesktop")))
                  (make-wrapper wrapper wrappee
                    `("WAYLAND_DISPLAY" + ("--enable-features=UseOzonePlatform"
                                           "--ozone-platform=wayland"
                                           "--enable-features=WebRTCPipeWireCapturer"
                                           "--enable-features=VaapiVideoDecoder"
                                           "--enable-features=VaapiIgnoreDriverChecks"
                                           "--enable-features=VaapiVideoEncoder"
                                           "--enable-features=VaapiVideoDecodeLinuxGL"
                                           "--enable-features=AcceleratedVideoDecodeLinuxGL"
                                           "--enable-features=AcceleratedVideoEncoder"
                                           "--disable-features=UseChromeOSDirectVideoDecoder"
                                           "--ignore-gpu-blocklist")))))))))
    (synopsis "Custom Discord App with better performance and improved linux
support")
    (description "Vesktop main features are:
@itemize
  @item @command{Vencord} preinstalled
  @item Much more lightweight and faster than the official Discord app
  @item @command{Linux Screenshare} with sound & wayland
  @item Much better privacy, since Discord has no access to your system
@end itemize")
    (home-page "https://github.com/Vencord/Vesktop")
    (license license:gpl3)))

(define ollama-bin
  (package
    (name "ollama-bin")
    (version "0.6.6")
    (source
     (origin
       (method url-fetch/tarbomb)
       (uri (string-append
             "https://github.com/ollama/ollama/releases/download/v" version
             "/ollama-linux-amd64.tgz"))
       (sha256
        (base32 "00ygy496j4zcrx4qq7vr5y18959w126b75w4fxk9k2b8j2k8axhv"))))
    (build-system binary-build-system)
    (supported-systems (list "x86_64-linux"))
    (arguments
      (list #:strip-binaries? #f
            #:install-plan ''(("." ""))))
    (inputs (list (list gcc "lib") glibc mesa cuda))
    (home-page "https://ollama.com")
    (synopsis "Get up and running with large language models")
    (description "Get up and running with large language models. Run Llama
2, Code Llama, and other models. Customize and create your own.")
    (license license:expat)))

(define-public spotify
  (let ((revision "g1d0fcf61"))
    (package
      (name "spotify")
      (version "1.2.79.425")
      (source
        (origin
          (method url-fetch)
          (uri
            (string-append "http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_"
                           version "." revision "_amd64.deb"))
          (sha256
            (base32 "1s7g2dpdwf1s5mhysyz5jm4r118zv8dj64h2ggm05ggzvnpcfhwq"))))
      (build-system chromium-binary-build-system)
      (arguments
        (list
          #:install-plan
          #~`(("usr/share/spotify/" "opt/spotify")
              ("usr/share/spotify/icons/" "share/icons")
              ("usr/share/spotify/spotify.desktop" "share/applications/spotify.desktop"))
          #:symlink-plan
          #~'(("opt/spotify/spotify" "bin/spotify"))))
      (synopsis "Play music from the Spotify music service")
      (description "Spotify is a digital music service that gives you access to
millions of songs.")
      (home-page "https://open.spotify.com/")
      (license #f))))

(define opentabletdriver-bin
  (package
    (name "opentabletdriver-bin")
    (version "0.6.5.1")
    (source
      (origin
        (method url-fetch)
        (uri (string-append
              "https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v"
              version "/opentabletdriver-" version "-x64.tar.gz"))
        (sha256
          (base32 "0p74avg03mqrqfvmidaagsq8lwancn1g3an9a2140qwqnc2439lf"))))
    (build-system binary-build-system)
    (arguments
      (list #:install-plan
            #~'(("usr/local/lib/opentabletdriver/OpenTabletDriver.Console" "bin/otd")
                ("usr/local/lib/opentabletdriver/OpenTabletDriver.Daemon" "bin/otd-daemon")
                ("usr/local/lib/opentabletdriver/OpenTabletDriver.UX.Gtk" "bin/otd-gui")
                ("etc" "lib")
                ("usr/local/share" "share")
                ("usr/local/lib/modprobe.d" "lib/modprobe.d")
                ("usr/local/lib/modules-load.d" "lib/modules-load.d")
                ("usr/local/lib/systemd" "lib/systemd"))))
    (inputs (list gcc-toolchain-15
                  glibc
                  gtk+
                  libnotify))
    (propagated-inputs (list dotnet))
    (home-page "https://opentabletdriver.net")
    (synopsis "OpenTabletDriver is an open source, cross platform, user mode tablet driver.")
    (description "The goal of OpenTabletDriver is to be cross platform as
possible with the highest compatibility in an easily configurable graphical
user interface.")
    (properties '((saayix-update? . #f)))
    (license (list license:lgpl3+))))

(define chromium-embedded-framework-src
  (let ((git-revision "cbc1c5b")
        (chromium-version "135.0.7049.52")
        (arch "linux64"))
    (package/inherit chromium-embedded-framework
      (name "chromium-embedded-framework-src")
      (version "135.0.17")
      (source (origin
                (method url-fetch)
                (uri (string-append
                      "https://cef-builds.spotifycdn.com/cef_binary_"
                      version
                      "+g" git-revision
                      "+chromium-" chromium-version
                      "_" arch "_minimal.tar.bz2"))
                (sha256
                 (base32
                  "1ijdxh9pyfabp5nprr1pig6xqw679fyxcdy3lapb3rrbws01kb14"))))
      (build-system binary-build-system)
      (arguments
       `(#:install-plan
         `(("." ""))))
      (inputs
        (modify-inputs (package-inputs chromium-embedded-framework)
          (append eudev))))))

(define-public linux-wallpaperengine
  (let ((commit "f79c29f067b2613895419e351033582464577154")
        (revision "1"))
    (package
      (name "linux-wallpaperengine")
      (version (git-version "0.1.0" revision commit))
      (source
        (origin
          (method git-fetch)
          (uri (git-reference
                 (url "https://github.com/Almamu/linux-wallpaperengine")
                 (commit commit)
                 (recursive? #t)))
          (file-name (git-file-name name version))
          (sha256
            (base32 "1l17fh30ysni4dlxpp1lpjbayzz41jx4ya5l2bc78cbawni9v100"))))
      (build-system cmake-build-system)
      (arguments
        (list #:tests? #f
              #:configure-flags
              #~(list (string-append "-DCEF_ROOT="
                                     #$(this-package-input "chromium-embedded-framework-src"))
                      "-DCMAKE_BUILD_TYPE=Release")
              #:imported-modules
              (append %cmake-build-system-modules
                      %chromium-binary-build-system-modules)
              #:modules '((guix build cmake-build-system)
                          ((saayix build chromium-binary-build-system)
                           #:prefix chromium-binary:)
                          (guix build utils))
              #:phases
              #~(modify-phases %standard-phases
                  (add-after 'unpack 'patch-steam-path
                    (lambda _
                      (substitute* "src/Steam/FileSystem/FileSystem.cpp"
                        (("\\.var/app/com.valvesoftware.Steam/\\.local/share/Steam/steamapps")
                         ".local/share/guix-sandbox-home/.local/share/Steam/steamapps")
                        (("snap/steam/common/.local/share/Steam/steamapps")
                         "games/SteamLibrary/steamapps"))))
                  (replace 'install
                    (lambda args
                      (apply (assoc-ref chromium-binary:%standard-phases 'install)
                             #:install-plan
                             '(("output/" "opt/linux-wallpaperengine/")
                               ("lib" ""))
                             args)))
                  (add-after 'install 'patchelf
                    (assoc-ref chromium-binary:%standard-phases 'patchelf))
                  (add-after 'patchelf 'symlink
                    (lambda args
                      (apply (assoc-ref chromium-binary:%standard-phases 'symlink)
                             #:symlink-plan
                             '(("opt/linux-wallpaperengine/linux-wallpaperengine"
                                "bin/linux-wallpaperengine"))
                             args)))
                  (add-after 'symlink 'install-wrapper
                    (assoc-ref chromium-binary:%standard-phases 'install-wrapper)))))
      (native-inputs
        (list pkg-config patchelf))
      (inputs
        (list chromium-embedded-framework-src
              glibc
              fftw
              freeglut
              glew
              glfw-3.4
              gcc-toolchain
              glm
              gmp
              nss
              nspr
              at-spi2-core
              cups
              libxcomposite
              pango
              cairo
              eudev
              kissfft
              libglvnd
              lz4
              mpv-minimal/wayland
              pulseaudio
              python
              sdl2
              wayland-protocols
              xrandr
              zlib))
      (home-page "https://github.com/Almamu/linux-wallpaperengine")
      (synopsis "Wallpaper Engine backgrounds for Linux")
      (description "This project allows you to run animated wallpapers from
Steam’s Wallpaper Engine right on your desktop.")
      (license license:gpl3))))
