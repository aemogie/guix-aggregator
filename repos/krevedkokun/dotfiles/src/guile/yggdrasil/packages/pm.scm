(define-module (yggdrasil packages pm)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:))

(define-public throttled
  (let* ((commit "970001ec38f501283c8f23b59e7368e2fbff1112")
         (revision "0")
         (version (git-version "0.9.2" revision commit)))
    (package
      (name "throttled")
      (version version)
      (home-page "https://github.com/erpalma/throttled")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url home-page)
               (commit commit)))
         (sha256
          (base32
           "1cjgw2kj6gm47yhxwg3ic6zw7qwb3gr56m3471wkz7158ccm6d96"))
         (file-name (git-file-name name version))))
      (build-system gnu-build-system)
      (inputs (list kmod
                    upower
                    python-wrapper
                    python-pygobject
                    python-dbus
                    python-configparser))
      (arguments
       (list
        #:tests? #f
        #:phases
        #~(modify-phases %standard-phases
            (delete 'configure)
            (delete 'build)
            (add-after 'unpack 'patch
              (lambda* (#:key inputs #:allow-other-keys)
                (substitute* "throttled.py"
                  (("/etc/throttled.conf") (string-append #$output "/etc/throttled.conf"))
                  (("'modprobe'") (format #f "'~a'" (which "modprobe")))
                  (("'upower'") (format #f "'~a'" (which "upower"))))))
            (replace 'install
              (lambda _
                (let ((bin (string-append #$output "/bin")))
                  (install-file "etc/throttled.conf" (string-append #$output "/etc"))
                  (install-file "mmio.py" bin)
                  (install-file "throttled.py" bin))))
            (add-after 'install 'wrap-python
              (lambda _
                (wrap-program (string-append #$output "/bin/throttled.py")
                  `("GUIX_PYTHONPATH" ":" prefix (,(getenv "GUIX_PYTHONPATH")))))))))
      (synopsis "")
      (description "")
      (license license:expat))))
