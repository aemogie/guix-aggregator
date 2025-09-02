(define-public tailscale
  (package
    (name "tailscale")
    (version "1.86.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/tailscale/tailscale")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1l8wqn2pd876cyyhfr9c7ry66jll1mfn4vfxdjdfck9gm6ydz346"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  (delete-file-recursively "tool")
                  (substitute* "net/tstun/tun_linux.go"
                    (("/sbin/(modprobe)" _ cmd) cmd))
                  (substitute* "go.mod"
                    (("1.24.4") "1.24"))))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? (not (%current-target-system)) ;TODO: Run test suite.
      #:go go-1.24
      #:install-source? #f
      #:import-path "."
      #:build-flags
      #~(list "-tags" "ts_include_cli"
              (string-append
               "-ldflags="
               " -X tailscale.com/version.longStamp="
               #$(package-version this-package)
               " -X tailscale.com/version.shortStamp="
               #$(package-version this-package)))
      #:modules
      '((ice-9 match)
        ((guix build gnu-build-system) #:prefix gnu:)
        (guix build go-build-system)
        (guix build utils))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'unpack
            (lambda args
              (unsetenv "GO111MODULE")
              (apply (assoc-ref gnu:%standard-phases 'unpack) args)
              (copy-recursively
               #+(this-package-native-input "vendored-go-dependencies")
               "vendor")))
          (replace 'install-license-files
            (assoc-ref gnu:%standard-phases 'install-license-files))
          (replace 'build
            (lambda* (#:key build-flags parallel-build? #:allow-other-keys)
              (let* ((njobs (if parallel-build? (parallel-job-count) 1)))
                (setenv "GOMAXPROCS" (number->string njobs))
                (for-each
                 (lambda (pkg)
                   (apply invoke "go" "build" "-ldflags=-s -w" "-trimpath"
                          "-o" (string-append #$output "/bin/" pkg)
                          `(,@build-flags
                            ,(string-append "tailscale.com/cmd/" pkg))))
                 '("derper"
                   "derpprobe"
                   "tailscaled"
                   "tsidp")))))
          (add-after 'install 'install-extras
            (lambda _
              (symlink (in-vicinity #$output "bin/tailscaled")
                       (in-vicinity #$output "bin/tailscale"))
              (let ((tailscale
                     (or (which "tailscale")
                         (in-vicinity #$output "bin/tailscale"))))
                (map
                 (match-lambda
                   ((shell . path)
                    (let ((file (in-vicinity #$output path)))
                      (mkdir-p (dirname file))
                      (with-output-to-file file
                        (lambda ()
                          (invoke tailscale "completion" shell))))))
                 '(("bash" . "etc/bash_completion.d/tailscale")
                   ("fish" . "share/fish/vendor_completions.d/tailscale.fish")
                   ("zsh"  . "share/zsh/site-functions/_tailscale"))))))
          (add-after 'install 'wrap-binaries
            (lambda* (#:key inputs #:allow-other-keys)
              (wrap-program (in-vicinity #$output "bin/tailscaled")
                `("PATH" ":" prefix
                  ,(map (lambda (cmd)
                          (dirname (search-input-file inputs cmd)))
                        '("bin/find"
                          "bin/getent"
                          "bin/modprobe"
                          "sbin/ip"
                          "sbin/iptables"
                          "sbin/resolvconf"
                          "sbin/sysctl"))))))
          (delete 'check)
          (add-after 'install 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (for-each
                 (lambda (cmd)
                   (invoke (string-append #$output "/bin/" cmd) "--help"))
                 '("derper"
                   "derpprobe"
                   "tailscaled"
                   "tsidp"))))))))
    (native-inputs
     (append
      (list (origin
              (method (go-mod-vendor #:go go-1.24))
              (uri (package-source this-package))
              (file-name "vendored-go-dependencies")
              (sha256
               (base32
                "0l4j763bk2k9pl99rvga1kk828szmjwl7vc9jvrrfq6bj6rd4171"))))
      (if (%current-target-system)
          (list this-package)
          '())))
    (inputs
     (list findutils glibc iproute iptables-nft kmod openresolv procps))
    (home-page "https://tailscale.com/")
    (synopsis "Mesh VPN service utilizing the WireGuard protocol and 2FA")
    (description
     "Tailscale is a mesh VPN service that simplifies the process of securely
connecting devices and services across various networks.  It allows you to
create a private network with minimal configuration and aims to remove the
complexity of building a trusted and secure network.")
    (license license:bsd-3)))
