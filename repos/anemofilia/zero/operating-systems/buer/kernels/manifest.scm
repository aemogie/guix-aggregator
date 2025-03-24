(use-modules (gnu packages base)
             (gnu packages commencement)
             (gnu packages flex)
             (gnu packages pciutils)
             (gnu packages linux)
             (gnu packages bison)
             (gnu packages perl)
             (gnu packages ncurses)
             (gnu packages pkg-config))

(packages->manifest
  (list gcc-toolchain
        gnu-make
        ncurses
        flex
        perl
        pciutils
        usbutils
        module-init-tools
        bison
        pkg-config))
