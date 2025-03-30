(define-module (misako packages linux)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (gnu packages linux)
  #:export (linux-latest))

(define (linux-url version)
  "Return a URL for Linux VERSION."
  (string-append "mirror://kernel.org"
                 "/linux/kernel/v" (version-major version) ".x"
                 "/linux-" version ".tar.xz"))

(define linux-latest
  (let* ((linux-version "6.14")
         (linux-hash "0w3nqh02vl8f2wsx3fmsvw1pdsnjs5zfqcmv2w2vnqdiwy1vd552"))
    (package
      (inherit
        (customize-linux
          #:name "linux-latest"
          #:linux linux-libre
          #:source (origin
                     (method url-fetch)
                     (uri (linux-url linux-version))
                     (sha256 (base32 linux-hash)))
          #:configs ""
          #:defconfig #f))
      (version linux-version)
      (home-page "https://www.kernel.org/")
      (synopsis "Linux kernel with nonfree binary blobs included")
      (description "The unmodified Linux kernel, including nonfree blobs, for
running Guix System on hardware which requires nonfree software to function."))))
