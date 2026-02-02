(define-module (operating-systems phenex)
  #|GNU bootloader|#
  #|•|# #:use-module (gnu bootloader)
  #|G|# #:use-module (gnu bootloader grub)

  #|GNU packages|#
  #|L|# #:use-module (gnu packages linux)

  #|GNU system|#
  #|•|# #:use-module (gnu system)
  #|L|# #:use-module (gnu system linux-initrd)
  #|P|# #:use-module (gnu system privilege)

  #|Guix|#
  #|G|# #:use-module (guix gexp)

  #|nonGNU packages|#
  #|L|# #:use-module (nongnu packages linux)

  #|nonGNU system|#
  #|L|# #:use-module (nongnu system linux-initrd)

  #|Operating-systems|#
  #|B|# #:use-module (operating-systems buer))

(define phenex
  (let* ((buer:bootloader (operating-system-bootloader buer))
         (buer:bootloader-theme (bootloader-configuration-theme buer:bootloader))
         (buer:privileged-programs (operating-system-privileged-programs buer)))
    (operating-system
     (inherit buer)
     (host-name "phenex")
     (bootloader
      (bootloader-configuration
       (inherit buer:bootloader)
       (targets `("/dev/disk/by-id/ata-LITEON_CV1-8B256_0018462003TG"))
       (theme (grub-theme
               (inherit buer:bootloader-theme)
                (resolution `(1920 . 1080))
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
             %base-firmware))
     (privileged-programs
      (cons (privileged-program
             (program (file-append brightnessctl "/bin/brightnessctl"))
             (setuid? #t))
            buer:privileged-programs)))))

phenex
