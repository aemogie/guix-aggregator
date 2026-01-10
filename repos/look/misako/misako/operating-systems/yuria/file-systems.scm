(define-module (misako operating-systems yuria file-systems)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system mapped-devices)
  #:export (%btrfs-ephemeral-file-systems
            %mapped-devices))

;; cryptsetup luksUUID /dev/nvme0n1p2
(define guix-device
  (uuid "2098de54-2aa0-41a8-91d1-e0d92a8ffeb7"))

(define efi-part
  (uuid "67BA-1B94" 'fat))

(define %mapped-devices
  (list (mapped-device
          (source guix-device)
          (target "guix")
          (type luks-device-mapping))))

(define root
  (file-system
    (device "none")
    (type "tmpfs")
    (mount-point "/")
    (check? #f)
    (needed-for-boot? #t)
    (options "mode=0755")))

(define home
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/home")
    (flags '(no-atime))
    (options "subvol=@home,discard=async,ssd")
    (dependencies %mapped-devices)))

(define snapshots
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/snapshots")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@snapshots")
    (dependencies %mapped-devices)))

(define root-user
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/root")
    (flags '(no-atime))
    (options "subvol=@root,discard=async,ssd")
    (dependencies %mapped-devices)))

(define boot
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/boot")
    (check? #f)
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "subvol=@boot,discard=async,ssd")
    (dependencies %mapped-devices)))

(define boot-efi
  (file-system
    (device efi-part)
    (type "vfat")
    (mount-point "/boot/efi")))

(define tmp
  (file-system
    (device "none")
    (type "tmpfs")
    (mount-point "/tmp")
    (check? #f)
    (needed-for-boot? #f)))

(define run
  (file-system
    (device "none")
    (type "tmpfs")
    (mount-point "/run")
    (check? #f)
    (needed-for-boot? #t)
    (options "mode=0755")))

(define var-run
  (file-system
    (device "none")
    (type "tmpfs")
    (mount-point "/var/run")
    (check? #f)
    (needed-for-boot? #t)
    (options "mode=0755")))

(define var-log
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/var/log")
    (check? #f)
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@var/log,ssd")
    (dependencies %mapped-devices)))

(define var-lib
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/var/lib")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@var/lib,ssd")
    (dependencies %mapped-devices)))

(define var-guix
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/var/guix")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@var/guix,ssd")
    (dependencies %mapped-devices)))

(define var-cache
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/var/cache")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@var/cache,ssd")
    (dependencies %mapped-devices)))

(define gnu-store
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/gnu/store")
    (needed-for-boot? #t)
    (flags '(read-only no-atime))
    (options "compress=zstd,subvol=@gnu/store,ssd")
    (dependencies %mapped-devices)))

(define gnu-persist
  (file-system
    (device (file-system-label "guix"))
    (type "btrfs")
    (mount-point "/gnu/persist")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "subvol=@gnu/persist,ssd")
    (dependencies %mapped-devices)))

(define gnu-persist-ssh
  (file-system
    (device "/gnu/persist/etc/ssh")
    (type "none")
    (mount-point "/etc/ssh")
    (flags '(no-atime bind-mount))))

(define gnu-persist-guix
  (file-system
    (device "/gnu/persist/etc/guix")
    (type "none")
    (mount-point "/etc/guix")
    (flags '(no-atime bind-mount))))

(define gnu-persist-wireguard
  (file-system
    (device "/gnu/persist/etc/wireguard")
    (type "none")
    (mount-point "/etc/wireguard")
    (flags '(no-atime bind-mount))))

(define gnu-persist-mullvad-vpn
  (file-system
    (device "/gnu/persist/etc/mullvad-vpn")
    (type "none")
    (mount-point "/etc/mullvad-vpn")
    (flags '(no-atime bind-mount))))

(define %btrfs-ephemeral-file-systems
  (list root
        home
        snapshots
        root-user
        boot
        boot-efi
        tmp
        run
        var-run
        var-log
        var-lib
        var-guix
        var-cache
        gnu-store
        gnu-persist
        gnu-persist-ssh
        gnu-persist-guix
        gnu-persist-wireguard
        gnu-persist-mullvad-vpn
        %pseudo-terminal-file-system
        %shared-memory-file-system
        %efivars-file-system))
