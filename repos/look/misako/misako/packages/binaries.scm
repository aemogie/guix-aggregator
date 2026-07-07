;; SPDX-FileCopyrightText: 2025 Murilo <murilo@disroot.org>
;;
;; SPDX-License-Identifier: GPL-3.0

(define-module (misako packages binaries)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages bootstrap)
  #:use-module (gnu packages cmake)
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
  #:use-module (gnu packages maths)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages music)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages sdl)
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
  #:use-module (nongnu packages chromium)
  #:use-module (nongnu packages dotnet)
  #:use-module (nongnu packages nvidia)
  #:use-module (radix packages video)
  #:use-module (saayix build-system binary)
  #:use-module (saayix build-system chromium-binary)
  #:use-module (saayix packages gtk)
  #:export (libdeep-filter-ladspa-bin
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
