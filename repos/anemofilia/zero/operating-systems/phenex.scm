(define-module (operating-systems phenex)
  #|GNU bootloader|#
  #|•|# #:use-module (gnu bootloader)
  #|G|# #:use-module (gnu bootloader grub)

  #|GNU packages|#
  #|L|# #:use-module (gnu packages linux)

  #|GNU services|#
  #|•|# #:use-module (gnu services)

  #|GNU system|#
  #|•|# #:use-module (gnu system)
  #|L|# #:use-module (gnu system linux-initrd)

  #|Guix|#
  #|G|# #:use-module (guix gexp)

  #|nonGNU packages|#
  #|L|# #:use-module (nongnu packages linux)

  #|nonGNU system|#
  #|s|# #:use-module (nongnu system linux-initrd)

  #|Operating-systems|#
  #|B|# #:use-module (operating-systems buer)

  #|Radix|#
  #|A|# #:use-module (radix artwork))

(define phenex
  (operating-system
   (inherit buer)
   (host-name "phenex")
   (bootloader
    (bootloader-configuration
     (inherit (operating-system-bootloader buer))
     (targets `("/dev/disk/by-id/ata-LITEON_CV1-8B256_0018462003TG"))
     (theme (grub-theme
              (resolution `(1920 . 1080))
              (color-normal
                '((fg . light-gray) (bg . black)))
              (color-highlight
                '((fg . black) (bg . light-gray)))
              (image (file-append %artwork-repository
                                  "/backgrounds/guix-silver-16-9.svg"))
              (gfxmode `("1920x1080x32"))))))

   (kernel linux-6.17)
   (initrd
    (lambda (file-systems . rest)
      (apply microcode-initrd
             file-systems
             #:initrd base-initrd
             #:microcode-packages (list intel-microcode)
             rest)))
   (firmware
    (cons* linux-firmware
           realtek-firmware
           %base-firmware))))

phenex
