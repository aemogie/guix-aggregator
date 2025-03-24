(define-module (operating-systems buer kernels)
  #:use-module (guix gexp)
  #:use-module ((gnu packages linux) #:select (customize-linux)))

#|------------------------------------------------------------------|
 |Specificities:                                                    |
 |------------------------------------------------------------------|
 | (lscpu)                                                          |
 | Architecture:           x86_64                                   |
 |   CPU op-mode(s):       32-bit, 64-bit                           |
 |   Address sizes:        36 bits physical, 48 bits virtual        |
 |   Byte Order:           Little Endian                            |
 | CPU(s):                 4                                        |
 |   On-line CPU(s) list:  0-3                                      |
 | Vendor ID:              GenuineIntel                             |
 |   Model name:           Intel(R) Core(TM) i5-3320M CPU @ 2.60GHz |
 |     CPU family:         6                                        |
 |     Model:              58                                       |
 |     Thread(s) per core: 2                                        |
 |     Core(s) per socket: 2                                        |
 |     Socket(s):          1                                        |
 |------------------------------------------------------------------|
 | (lspci -k)                                                       |
 | Audio device driver:              snd_hda_intel                  |.
 | Ethernet controller driver:       e1000e                         |.
 | Host bridge driver:               ivb_uncore                     |
 | ISA bridge driver:                lpc_ich                        |.
 | Network controller driver:        ath9k                          |.
 | PCI bridge driver:                pcieport                       |
 | SATA controller driver:           ahci                           |
 | SD Host controller driver:        sdhci-pci                      |
 | SMBus driver:                     i801_smbus                     |
 | USB controller drivers:           ehci-pci, xhci_hcd             |.
 | VGA compatible controller driver: i915                           |.
 |------------------------------------------------------------------|
 | (observations)                                                   |
 | - defconfigs based on GNU Guix Linux-libre defconfigs for x86_64 |.
 | - no bluetooth support                                           |.
 | - no nvme support                                                |.
 | - no efi support                                                 |
 |------------------------------------------------------------------|#

(define-public linux-libre-6.13
  (customize-linux
    #:name "linux-libre"
    #:linux (@ (gnu packages linux) linux-libre-6.13)
    #:source (@ (gnu packages linux) linux-libre-6.13-source)
    #:defconfig (local-file "kernels/6.13.conf")
    #:extra-version "buer"))
