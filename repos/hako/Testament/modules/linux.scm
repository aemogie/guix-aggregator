;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(define-module (linux)
  ;; Guile builtins
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  ;; Utilities
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  ;; Guix packages
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages file-systems)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages onc-rpc)
  #:use-module (gnu packages pkg-config)
  #:export (linux-with-zfs
            default-initrd-configs
            cachyos-configs))

(define* (linux-with-zfs linux #:optional (zfs zfs))
  "Return a kernel package based on LINUX, with ZFS kernel modules built in."
  (let ((zfs-directory
         (string-append (package-name zfs) "-" (package-version zfs))))
    (package
      (inherit linux)
      (arguments
       (substitute-keyword-arguments arguments
         ((#:substitutable? _ #t) #f)
         ((#:phases phases)
          #~(modify-phases #$phases
              (add-after 'unpack 'unpack-zfs
                (lambda* (#:key inputs #:allow-other-keys)
                  (invoke "tar" "xf" #+(package-source zfs))
                  (with-directory-excursion #$zfs-directory
                    ;; Copied from zfs package.
                    (substitute* "module/os/linux/zfs/zfs_ctldir.c"
                      (("/usr/bin/env\", \"umount")
                       (string-append
                        (search-input-file inputs "/bin/umount") "\", \"-n"))
                      (("/usr/bin/env\", \"mount")
                       (string-append
                        (search-input-file inputs "/bin/mount") "\", \"-n"))))))
              ;; https://github.com/openzfs/zfs/issues/10450#issuecomment-643654436
              (add-after 'patch-source-shebangs 'add-zfs-to-kernel-tree
                (lambda _
                  (invoke "make" "defconfig" "prepare")
                  (with-directory-excursion #$zfs-directory
                    (invoke "./autogen.sh")
                    (substitute* "configure"
                      (("/bin/sh") (which "sh")))
                    (invoke "./configure" "--enable-linux-builtin"
                            "--with-linux=.."
                            "--with-linux-obj=..")
                    (invoke "./copy-builtin" ".."))
                  (delete-file-recursively #$zfs-directory)))
              (add-after 'configure 'enable-zfs
                (lambda _
                  (for-each
                   (lambda (config)
                     (invoke "./scripts/config" "--enable" config))
                   '("CONFIG_CRYPTO_DEFLATE"
                     "CONFIG_ZLIB_DEFLATE"
                     "CONFIG_KALLSYMS"
                     "CONFIG_EFI_PARTITION"
                     "CONFIG_ZFS"))))))))
      (native-inputs
       (modify-inputs native-inputs
         (prepend autoconf
                  automake
                  libtool
                  pkg-config)))
      (inputs
       (modify-inputs inputs
         (prepend libtirpc
                  util-linux
                  `(,util-linux "lib")))))))

(define* (default-initrd-configs
           #:optional
           (system (or (%current-target-system)
                       (%current-system))))
  "Kernel configurations required by 'default-initrd-modules'."
  `("CONFIG_NLS_ISO8859_1=m"

    "CONFIG_CRYPTO_SERPENT=m"
    "CONFIG_CRYPTO_WP512=m"
    "CONFIG_DM_CRYPT=m"

    "CONFIG_BLK_DEV_NVME=m"
    "CONFIG_MMC_BLOCK=m"
    "CONFIG_SATA_AHCI=m"
    "CONFIG_USB_STORAGE=m"
    "CONFIG_USB_UAS=m"
    ,@(if (string-match "^(x86_64|i[3-6]86)-" system)
          '("CONFIG_PATA_ACPI=m"
            "CONFIG_PATA_ATIIXP=m"
            "CONFIG_SCSI_ISCI=m")
          '())

    "CONFIG_HW_RANDOM_VIRTIO=m"
    "CONFIG_SCSI_VIRTIO=m"
    "CONFIG_VIRTIO_BALLOON=m"
    "CONFIG_VIRTIO_BLK=m"
    "CONFIG_VIRTIO_CONSOLE=m"
    "CONFIG_VIRTIO_MMIO=m"
    "CONFIG_VIRTIO_NET=m"
    "CONFIG_VIRTIO_PCI=m"

    "CONFIG_HID_GENERIC=m"
    "CONFIG_USB_HID=m"
    ,@(if (target-riscv64? system)
          '()
          '("CONFIG_HID_APPLE=m"))))

;; https://github.com/CachyOS/linux-cachyos
(define* (cachyos-configs #:key cachy-config?
                          cpusched
                          cc-harder?
                          per-gov?
                          tcp-bbr3?
                          HZ-ticks
                          tickrate
                          preempt
                          hugepage
                          processor-opt)
  `(,@(match processor-opt
        ('generic
         '("CONFIG_GENERIC_CPU=y"
           "CONFIG_MZEN4"
           "CONFIG_X86_NATIVE_CPU"))
        ('zen4
         '("CONFIG_GENERIC_CPU"
           "CONFIG_MZEN4=y"
           "CONFIG_X86_NATIVE_CPU"))
        ('native
         '("CONFIG_GENERIC_CPU"
           "CONFIG_MZEN4"
           "CONFIG_X86_NATIVE_CPU=y"))
        (_ '()))
    ,@(if cachy-config?
          '("CONFIG_CACHY=y")
          '())
    ,@(match cpusched
        ((or 'cachyos 'bore 'hardened)
         '("CONFIG_SCHED_BORE=y"))
        ('bmq
         '("CONFIG_SCHED_ALT=y"
           "CONFIG_SCHED_BMQ=y"))
        ('eevdf
         '())
        ('rt
         '("CONFIG_PREEMPT_RT=y"))
        ('rt-bore
         '("CONFIG_SCHED_BORE=y"
           "CONFIG_PREEMPT_RT=y"))
        (_ '()))
    ,@(match HZ-ticks
        ((or 100 250 500 600 750 1000)
         `("CONFIG_HZ_300"
           ,(format #f "CONFIG_HZ_~a=y" HZ-ticks)
           ,(format #f "CONFIG_HZ=~a" HZ-ticks)))
        (300
         '("CONFIG_HZ_300=y"
           "CONFIG_HZ=300"))
        (_ '()))
    ,@(if per-gov?
          '("CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL"
            "CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y")
          '())
    ,@(match tickrate
        ('perodic
         '("CONFIG_NO_HZ_IDLE"
           "CONFIG_NO_HZ_FULL"
           "CONFIG_NO_HZ"
           "CONFIG_NO_HZ_COMMON"
           "CONFIG_HZ_PERIODIC=y"))
        ('idle
         '("CONFIG_HZ_PERIODIC"
           "CONFIG_NO_HZ_FULL"
           "CONFIG_NO_HZ_IDLE=y"
           "CONFIG_NO_HZ"
           "CONFIG_NO_HZ_COMMON"))
        ('full
         '("CONFIG_HZ_PERIODIC"
           "CONFIG_NO_HZ_IDLE"
           "CONFIG_CONTEXT_TRACKING_FORCE"
           "CONFIG_NO_HZ_FULL=y"
           "CONFIG_NO_HZ=y"
           "CONFIG_NO_HZ_COMMON=y"
           "CONFIG_CONTEXT_TRACKING=y")))
    ,@(if (not (member cpusched '(rt rt-bore)))
          (match preempt
            ('full
             '("CONFIG_PREEMPT_DYNAMIC=y"
               "CONFIG_PREEMPT=y"
               "CONFIG_PREEMPT_VOLUNTARY"
               "CONFIG_PREEMPT_LAZY"
               "CONFIG_PREEMPT_NONE"))
            ('lazy
             '("CONFIG_PREEMPT_DYNAMIC=y"
               "CONFIG_PREEMPT"
               "CONFIG_PREEMPT_VOLUNTARY"
               "CONFIG_PREEMPT_LAZY=y"
               "CONFIG_PREEMPT_NONE"))
            ('voluntary
             '("CONFIG_PREEMPT_DYNAMIC"
               "CONFIG_PREEMPT=y"
               "CONFIG_PREEMPT_VOLUNTARY=y"
               "CONFIG_PREEMPT_LAZY"
               "CONFIG_PREEMPT_NONE"))
            ('none
             '("CONFIG_PREEMPT_DYNAMIC"
               "CONFIG_PREEMPT"
               "CONFIG_PREEMPT_VOLUNTARY"
               "CONFIG_PREEMPT_LAZY"
               "CONFIG_PREEMPT_NONE=y"))
            (_ '()))
          '())
    ,@(if cc-harder?
          '("CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE"
            "CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3=y")
          '())
    ,@(if tcp-bbr3?
          '("CONFIG_TCP_CONG_CUBIC=m"
            "CONFIG_DEFAULT_CUBIC"
            "CONFIG_TCP_CONG_BBR=y"
            "CONFIG_DEFAULT_BBR=y"
            "CONFIG_DEFAULT_TCP_CONG=\"bbr\""
            "CONFIG_NET_SCH_FQ_CODEL=m"
            "CONFIG_NET_SCH_FQ=y"
            "CONFIG_DEFAULT_FQ_CODEL"
            "CONFIG_DEFAULT_FQ=y")
          '())
    ,@(match hugepage
        ('always
         '("CONFIG_TRANSPARENT_HUGEPAGE_MADVISE"
           "CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y"))
        ('madvise
         '("CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS"
           "CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y"))
        (_ '()))
    "CONFIG_USER_NS=y"))
