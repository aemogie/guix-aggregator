;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2023-2026 Hilton Chain <hako@ultrarare.space>

(define-module (common)
  ;; Guile builtins
  #:use-module (ice-9 match)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-1)
  ;; Utilities
  #:use-module ((guix diagnostics) #:select (leave))
  #:use-module (guix gexp)
  #:use-module ((guix i18n) #:select (G_))
  #:use-module (guix modules)
  #:use-module (guix packages)
  #:use-module (guix store)
  ;; Guix build systems
  #:use-module (guix build-system copy)
  ;; Guix packages
  #:use-module (gnu packages linux)
  #:use-module (nongnu packages linux)
  #:export (testament-plain

            sops-str
            sops-num

            %sops-chapra
            %sops-dorphine
            %sops-nuporta

            %guix-keys
            %ssh-key-deploy
            %ssh-key-hako
            %ssh-key-jonathan
            %ssh-key-podiki
            %ssh-key-podiki

            %network-manager-ipv6-privacy
            %network-manager-random-mac-address

            %xdg-data-home
            %xdg-base-directory-env-vars

            linux-lts/dolly
            manage-cuirass))


;;;
;;; Find files within the repository.
;;;

(define testament-path
  (getcwd))

(define (testament-plain . name)
  (let ((plain (in-vicinity testament-path "files/plain")))
    (match name
      (()
       (local-file plain #:recursive? #t))
      ((file)
       (or (search-path (list plain) file)
           (leave (G_ "file '~a' not found.~%") file))))))


;;;
;;; SOPS secrets.
;;;

(define* (get-sops-secret key #:key file (number? #f))
  "Return a string (or number if NUMBER? is set to #t) of SOPS secret for KEY
stored in FILE.  The result will be publicly available in '/gnu/store', YOU ARE
WARNED."
  (let* ((file-path
          (with-store store
            (run-with-store store
              (lower-object file))))
         (cmd
          (format #f "sops --decrypt --extract '~a' '~a'"
                  ((@@ (sops secrets) list-key->string-key) key)
                  file-path))
         (port (open-input-pipe cmd))
         (secret (get-string-all port)))
    (close-pipe port)
    (if number?
        (string->number secret)
        secret)))

(define (sops-str file key)
  (get-sops-secret key #:file file))

(define (sops-num file key)
  (get-sops-secret key #:file file #:number? #t))

(define %sops-chapra
  (local-file "../../../Workspace/SOPS/chapra.yaml"))
(define %sops-dorphine
  (local-file "../../../Workspace/SOPS/dorphine.yaml"))
(define %sops-nuporta
  (local-file "../../../Workspace/SOPS/nuporta.yaml"))


;;;
;;; Keys
;;;

(define %guix-keys
  (list (plain-file "dorphine.pub"
          "(public-key (ecc (curve Ed25519)
(q #A279175682D0DAE3E11268E67E1F3FA47C38D7E509F7725567CF891E248E719F#)))")
        (plain-file "nuporta.pub"
          "(public-key (ecc (curve Ed25519)
(q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))")
        (plain-file "ignamma.pub"
          "(public-key (ecc (curve Ed25519)
(q #6FEEB15C4363F9975EB15C908EC911A4362E486DA642431FA2438C0B1C3D55F5#)))")
        (plain-file "workers-hako.pub"
          "(public-key (ecc (curve Ed25519)
(q #7927EA1162184C1FAA62D20C111121A4604F00956E69F0FEB89EEE1721647897#)))")
        (plain-file "workers-poesty.pub"
          "(public-key (ecc (curve Ed25519)
(q #8C4662FA0BC955B33261EEA5AA15F33081A7BEC991E5F990F7382F0988459B37#)))")
        ;; Guix Moe
        (plain-file "guix-moe-old.pub"
          "(public-key (ecc (curve Ed25519)
(q #374EC58F5F2EC0412431723AF2D527AD626B049D657B5633AAAEBC694F3E33F9#)))")
        (plain-file "guix-moe.pub"
          "(public-key (ecc (curve Ed25519)
(q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))")
        ;; Nonguix
        (plain-file "nonguix.pub"
          "(public-key (ecc (curve Ed25519)
(q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))")))

(define %ssh-key-deploy
  (plain-file "deploy.pub"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLWIp8y5/JGBaw+yFA5MFB5nlFpEx/tjc0q0Ij9KjTu\n"))
(define %ssh-key-hako
  (plain-file "hako.pub"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcTj1N3cL/bh2Uvwh5/YubhZplPFnvGk/iVHQs3FWV2\n"))
(define %ssh-key-jonathan
  (plain-file "jonathan.pub"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgzHvP3BRTIZ960LVglrK8w/C0+6Z5VM8/Q5Uwa0o+Z"))
(define %ssh-key-podiki
  (plain-file "podiki.pub"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaSmW/3uq5L6ZP6gWmRw5RiTTg0es1PrbAo/x4vkPzwIKTrMFOCBCmcuH3vOCkEZJtNy3OpXbt/a3tDW+cc6dkeq2H4WpogQvyMTXreFS2phMgDTEXW2gGZIP6fA33CHERmhd9A/m0A+NH5KGAmLDQNK8QgPgIjZuseJYtYHNCnN2TCsWQYnbZtVQF5CS6iBUILpVp6p7QlSUokiCGaPjZfrjSFCm1hUPjJYSkv0NTq8TzyDfU2quqP7TBCj4WBi9HoW9+a8tN2TQ/+GYbGqlFljeNdz3vzItcHjidHOQL/42mpvzgZx7o7dtrqX9stp+mI3oBREYSD0bMyvND/dEBRWIbpFvbyYx/leMKq9yUcFNyI2lztk17ObaQkDLxlq4ClytgEtdbP6X0gua29FYK/YlAi13NptK6uy2xB2gsEIt5P4N3u+gZCNA0U3IVd7iMRSpg6PWiL1JguvhYSD5vGOnOjiXVlBCKn+ErTO9Ey/BZqwVBZMeDwynFnU1mYnkxtA+G54VI77gj24FrHw/ClOdJOdBUGAso9P3sFjdykkAJyKd4jiFzpDTOOJNs8qKhmFFzJBnJjn7nzwjElwOCZXdDKTrKqF/51WEqpNr8Za2QjRirV4m7n6FnyyD38b24InAVa+yze3qDI9yk2vjPdtFGCeLODSEjfV3U1z1hiw=="))


;;;
;;; NetworkManager
;;;

(define %network-manager-ipv6-privacy
  `("ip6-privacy.conf"
    ,(plain-file "ip6-privacy.conf" "\
# Use IPv6 Privacy Extensions.
[connection]
ipv6.ip6-privacy=2\n")))

;; NOTE: When using on cloud machines, refer to the terms of the provider
;; first.
(define %network-manager-random-mac-address
  `("rand_mac.conf"
   ,(plain-file "rand_mac.conf" "\
# Generate a random MAC for each network connection and associate the two
# permanently.
[connection-mac-randomization]
ethernet.cloned-mac-address=stable
wifi.cloned-mac-address=stable\n")))


;;;
;;; XDG
;;;

(define %xdg-data-home
  (or (getenv "XDG_DATA_HOME")
      (in-vicinity (getenv "HOME") ".local/share")))

;; Source: <https://wiki.archlinux.org/title/XDG_Base_Directory>
(define %xdg-base-directory-env-vars
  '(;; bash
    ("HISTFILE" . "$XDG_STATE_HOME/bash/history")
    ;; docker
    ("DOCKER_CONFIG" . "$XDG_CONFIG_HOME/docker")
    ;; gdb
    ("GDBHISTFILE" . "$XDG_STATE_HOME/gdb/history")
    ;; go
    ("GOMODCACHE" . "$XDG_CACHE_HOME/go/mod")
    ("GOPATH" . "$XDG_DATA_HOME/go")
    ;; gradle
    ("GRADLE_USER_HOME" . "$XDG_DATA_HOME/gradle")
    ;; guile
    ("GUILE_HISTORY" . "$XDG_STATE_HOME/guile/history")
    ;; java
    ("_JAVA_OPTIONS" . "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java")
    ;; luanti
    ("MINETEST_USER_PATH" . "$XDG_DATA_HOME/luanti")
    ;; node
    ("NPM_CONFIG_USERCONFIG" . "$XDG_CONFIG_HOME/npm/npmrc")
    ;; nvidia-driver
    ("CUDA_CACHE_PATH" . "$XDG_CACHE_HOME/nv")
    ;; password-store
    ("PASSWORD_STORE_DIR" . "$XDG_DATA_HOME/pass")
    ;; python
    ;; TODO: Python 3.13.
    ("PYTHON_HISTORY" . "$XDG_STATE_HOME/python/history")
    ;; rust
    ("CARGO_HOME" . "$XDG_DATA_HOME/cargo")
    ;; sqlite
    ("SQLITE_HISTORY" . "$XDG_STATE_HOME/sqlite_history")
    ;; wget
    ("WGETRC" . "$XDG_CONFIG_HOME/wgetrc")))


;;;
;;; Packages
;;;

(define linux-lts/dolly
  (customize-linux
   #:name "linux-dolly"
   #:linux linux-lts
   #:source
   (origin
     (inherit (package-source linux-lts))
     (patches
      (map (lambda (patch)
             (local-file (canonicalize-path (in-vicinity "../Workspace/Repository/linux/kernel-patches/6.12" patch))))
           '("arch-patches-sep/0002-arch-Kconfig-Default-to-maximum-amount-of-ASLR-bits.patch"
             "bbr3-patches/0001-tcp-bbr3-initial-import.patch"))))))

(define manage-cuirass
  (let ((script
         (program-file "manage-cuirass.scm"
           #~(begin
               (use-modules (ice-9 format) (ice-9 match))
               (define %services
                 '("cuirass"
                   "cuirass-remote-server"
                   "cuirass-remote-worker"
                   "cuirass-web"))
               (define %actions
                 '("status"
                   "start"
                   "stop"
                   "restart"
                   "enable"
                   "disable"))
               (define (service? service)
                 (member service %services))
               (define (action? action)
                 (member action %actions))

               (match (cdr (command-line))
                 (((? service? service) (? action? action))
                  (system* "herd" action service))
                 (_
                  (format (current-error-port) "~
Usage: manage-cuirass SERVICE ACTION

SERVICE:
~{- ~a
~}
ACTION:
~{- ~a
~}" %services %actions)
                  (exit 1)))))))
    (package
      (name "manage-cuirass")
      (version "0.0.0")
      (source #f)
      (build-system copy-build-system)
      (arguments
       (list
        #:phases
        #~(modify-phases %standard-phases
            (delete 'unpack)
            (replace 'install
              (lambda _
                (call-with-output-file "manage-cuirass.c"
                  (lambda (port)
                    (format port "~
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv, char **envp) {
  setuid(geteuid());
  *argv = ~s;
  execve(*argv, argv, envp);
  perror(*argv);
  return 127;
}~%"
                            #$script)))
                (invoke "gcc" "manage-cuirass.c" "-o" "manage-cuirass")
                (install-file "manage-cuirass" (in-vicinity #$output "bin")))))))
      (home-page "")
      (synopsis "")
      (description "")
      (license #f))))
