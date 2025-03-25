(use-modules (gnu packages)
             (gnu packages base)
             (gnu packages c)
             (gnu packages clojure)
	     (gnu packages cmake)
             (gnu packages commencement)
             (gnu packages elf)
             (gnu packages golang)
             (gnu packages gdb)
             (gnu packages guile)
             (gnu packages java)
             (gnu packages jupyter)
             (gnu packages libffi)
             (gnu packages lisp)
             (gnu packages llvm)
             (gnu packages lua)
             (gnu packages m4)
             (gnu packages node)
             (gnu packages pkg-config)
             (gnu packages python)
             (gnu packages python-xyz)
             (gnu packages racket)
             (gnu packages scheme)
             (gnu packages ssh)

             (nongnu packages clojure)
             (nongnu packages lisp)

             (guix packages))

(packages->manifest
 (list
  openssh
  ;; C/C++
  tcc
  llvm clang clang-runtime clang-toolchain
  glibc gdb gcc-toolchain
  gnu-make cmake pkg-config m4
  ;; Binaries
  patchelf coreutils binutils elfutils
  ;; JVM & Clojure
  icedtea clojure clojure-tools leiningen
  ;; CL
  libffi ;; For ECL
  ccl ecl abcl gcl clisp allegro-cl
  ;; Lisps that are not CL
  racket kawa chicken gauche gambit-c gerbil stklos
  ;; Other
  lua go python jupyter node-lts))
