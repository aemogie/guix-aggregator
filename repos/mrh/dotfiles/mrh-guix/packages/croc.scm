(define-module (mrh-guix packages croc)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system go)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages golang-xyz)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages golang-crypto)
  #:use-module (gnu packages syncthing))

(define-public go-github-com-chzyer-test
  (package
   (name "go-github-com-chzyer-test")
   (version "1.0.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/chzyer/test")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1axdlcnx2qjsn5wsr2pr1m0w0a8k4nk5kkrngh742fgh81vzzy8s"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/chzyer/test"))
   (native-inputs `(("go-github-com-chzyer-logex" ,go-github-com-chzyer-logex)))
   (home-page "https://github.com/chzyer/test")
   (synopsis "test")
   (description #f)
   (license license:expat)))

(define-public go-github-com-chzyer-logex
  (package
   (name "go-github-com-chzyer-logex")
   (version "1.2.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/chzyer/logex")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0c9yr3r7dl3lcs22cvmh9iknihi9568wzmdywmc2irkjdrn8bpxw"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/chzyer/logex"))
   (home-page "https://github.com/chzyer/logex")
   (synopsis "Logex")
   (description
    "An golang log lib, supports tracing and level, wrap by standard log lib")
   (license license:expat)))

(define-public go-github-com-chzyer-readline
  (package
   (name "go-github-com-chzyer-readline")
   (version "1.5.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/chzyer/readline")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1msh9qcm7l1idpmfj4nradyprsr86yhk9ch42yxz7xsrybmrs0pb"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/chzyer/readline"))
   (native-inputs `(("go-github-com-chzyer-logex" ,go-github-com-chzyer-logex)
            ("go-golang-org-x-sys" ,go-golang-org-x-sys)
            ("go-github-com-chzyer-test" ,go-github-com-chzyer-test)))
   (home-page "https://github.com/chzyer/readline")
   (synopsis "Guide")
   (description
    "Readline is a pure go implementation for GNU-Readline kind library.")
   (license license:expat)))

(define-public go-github-com-denisbrodbeck-machineid
  (package
   (name "go-github-com-denisbrodbeck-machineid")
   (version "1.0.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/denisbrodbeck/machineid")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "075rqb2f9hla9jwc6823jkkb3xcv6azz3phndbssssn2dps07cib"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/denisbrodbeck/machineid"))
   (home-page "https://github.com/denisbrodbeck/machineid")
   (synopsis
    "machineid provides support for reading the unique machine id of most host OS's (without admin privileges)")
   (description
    "Package machineid provides support for reading the unique machine id of most OSs
(without admin privileges).")
   (license license:expat)))

(define-public go-gopkg-in-tylerb-is
  (package
   (name "go-gopkg-in-tylerb-is")
   (version "1.1.2")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://gopkg.in/tylerb/is.v1")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1xva69xnvwfkp8axlj62vga20iafkipanvd95csbx9cwnsdk2xif"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "gopkg.in/tylerb/is.v1"
      #:unpack-path "gopkg.in/tylerb/is.v1"))
   (home-page "https://gopkg.in/tylerb/is.v1")
   (synopsis "is")
   (description
    "Is provides a quick, clean and simple framework for writing Go tests.")
   (license license:expat)))

(define-public go-github-com-kalafut-imohash
  (package
   (name "go-github-com-kalafut-imohash")
   (version "1.0.2")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/kalafut/imohash")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0c6rzzxcw89qz9q96ck4xwm3vavndc737drcv0s70p7w7qxv620w"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/kalafut/imohash"))
   (native-inputs `(("go-gopkg-in-tylerb-is" ,go-gopkg-in-tylerb-is)
            ("go-github-com-twmb-murmur3" ,go-github-com-twmb-murmur3)))
   (home-page "https://github.com/kalafut/imohash")
   (synopsis "imohash")
   (description
    "Package imohash implements a fast, constant-time hash for files.  It is based
atop murmurhash3 and uses file size and sample data to construct the hash.")
   (license license:expat)))

(define-public go-github-com-schollz-cli
  (package
    (name "go-github-com-schollz-cli")
    (version "2.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/schollz/cli")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0wlqfhsrfib4b5b5xlkmgwglpzajjabrf4wisp7q8nvnw9ky86jh"))))
    (build-system go-build-system)
    (arguments
     '(#:tests? #f
       #:import-path "github.com/schollz/cli/v2"))
    (native-inputs `(("go-gopkg-in-yaml-v3" ,go-gopkg-in-yaml-v3)
                     ("go-github-com-cpuguy83-go-md2man" ,go-github-com-cpuguy83-go-md2man)
                     ("go-github-com-burntsushi-toml" ,go-github-com-burntsushi-toml)))
    (home-page "https://github.com/schollz/cli")
    (synopsis "cli")
    (description
     "Package cli provides a minimal framework for creating and organizing command
line Go applications.  cli is designed to be easy to understand and write, the
most simple cli application can be written as follows:")
    (license license:expat)))

(define-public go-github-com-schollz-logger
  (package
    (name "go-github-com-schollz-logger")
    (version "1.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/schollz/logger")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1680348j54vwfx7sczygchrd9dabnycj3mpxg3fmpf9a356vd2af"))))
    (build-system go-build-system)
    (arguments
     '(#:tests? #f
       #:import-path "github.com/schollz/logger"))
    (home-page "https://github.com/schollz/logger")
    (synopsis "logger")
    (description
     " @@url{https://travis-ci.org/schollz/logger,(img (@@ (src
https://img.shields.io/travis/schollz/logger.svg?style=flat-square) (alt Build
Status)))} @@url{https://godoc.org/github.com/schollz/logger,(img (@@ (src
http://img.shields.io/badge/godoc-reference-5272B4.svg?style=flat-square) (alt
Go Doc)))}")
    (license license:expat)))

(define-public go-github-com-schollz-mnemonicode
  (package
   (name "go-github-com-schollz-mnemonicode")
   (version "1.0.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/schollz/mnemonicode")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "056jm384yfry3l4qm68j65x32mx9khizhzqrd347w65c4dnrys1s"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/schollz/mnemonicode"))
   (native-inputs `(("go-golang-org-x-text" ,go-golang-org-x-text)))
   (home-page "https://github.com/schollz/mnemonicode")
   (synopsis "Mnemonicode")
   (description "Package mnemonicode …")
   (license license:expat)))

(define-public go-github-com-schollz-pake
  (package
   (name "go-github-com-schollz-pake")
   (version "3.0.5")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/schollz/pake")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1iq4py234ch784k5pdvwxldndxvph60jjcfbg1svs3ym21kvr748"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/schollz/pake/v3"))
   (native-inputs `(("go-github-com-tscholl2-siec" ,go-github-com-tscholl2-siec)))
   (home-page "https://github.com/schollz/pake")
   (synopsis "pake")
   (description
    "This library will help you allow two parties to generate a mutual secret key by
using a weak key that is known to both beforehand (e.g. via some other channel
of communication).  This is a simple API for an implementation of
password-authenticated key exchange (PAKE).  This protocol is derived from
@@url{https://crypto.stanford.edu/~dabo/cryptobook/@code{BonehShoup_0_4.pdf,Dan}
Boneh and Victor Shoup's cryptography book} (pg 789, \"PAKE2 protocol).  I
decided to create this library so I could use PAKE in my file-transfer utility,
@@url{https://github.com/schollz/croc,croc}.")
   (license license:expat)))

(define-public go-github-com-schollz-peerdiscovery
  (package
   (name "go-github-com-schollz-peerdiscovery")
   (version "1.7.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/schollz/peerdiscovery")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1500w6anmgdr7j07sby0qjdixr55mfbckh8x4rm4vvlzd9w7lby4"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/schollz/peerdiscovery"))
   (native-inputs `(("go-golang-org-x-net" ,go-golang-org-x-net)
            ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
            ("go-golang-org-x-sys" ,go-golang-org-x-sys)))
   (home-page "https://github.com/schollz/peerdiscovery")
   (synopsis "peerdiscovery")
   (description
    " @@url{https://goreportcard.com/report/github.com/schollz/peerdiscovery,(img (@@
(src
https://goreportcard.com/badge/github.com/schollz/peerdiscovery?style=flat-square)
(alt Go Report)))} @@url{https://godoc.org/github.com/schollz/peerdiscovery,(img
(@@ (src
http://img.shields.io/badge/godoc-reference-5272B4.svg?style=flat-square) (alt
Go Doc)))}")
   (license license:expat)))

(define-public go-github-com-cpuguy83-go-md2man
  (package
   (name "go-github-com-cpuguy83-go-md2man")
   (version "2.0.3")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/cpuguy83/go-md2man")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1a7l569x9sb0s3siyc7w2gfyyq6xc6587i0g16j9gx25x8vjw03f"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/cpuguy83/go-md2man/v2"))
   (native-inputs `(("go-github-com-russross-blackfriday" ,go-github-com-russross-blackfriday)))
   (home-page "https://github.com/cpuguy83/go-md2man")
   (synopsis "go-md2man")
   (description "Converts markdown into roff (man pages).")
   (license license:expat)))

(define-public go-github-com-magisterquis-connectproxy
  (package
   (name "go-github-com-magisterquis-connectproxy")
   (version "0.0.0-20200725203833-3582e84f0c9b")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/magisterquis/connectproxy")
       (commit (go-version->git-ref version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "19l94ahyg33z186fiymbjdc8pb0rzknz46xs3rb7wzqq84mni4p5"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/magisterquis/connectproxy"))
   (native-inputs `(("go-golang-org-x-net" ,go-golang-org-x-net)))
   (home-page "https://github.com/magisterquis/connectproxy")
   (synopsis "ConnectProxy")
   (description
    "Package connectproxy implements a proxy.Dialer which uses HTTP(s) CONNECT
requests.")
   (license license:zlib)))

(define-public go-github-com-russross-blackfriday
  (package
   (name "go-github-com-russross-blackfriday")
   (version "2.1.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/russross/blackfriday")
       (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0d1rg1drrfmabilqjjayklsz5d0n3hkf979sr3wsrw92bfbkivs7"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/russross/blackfriday/v2"))
   (home-page "https://github.com/russross/blackfriday")
   (synopsis "Blackfriday")
   (description "Package blackfriday is a markdown processor.")
   (license license:bsd-2)))

(define-public go-github-com-tscholl2-siec
  (package
   (name "go-github-com-tscholl2-siec")
   (version "0.0.0-20210707234609-9bdfc483d499")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
       (url "https://github.com/tscholl2/siec")
       (commit (go-version->git-ref version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0cyl982hkvdp4y5lq152w46xbxqzd2k0vggzjkzdb0pbirbq3ym9"))))
   (build-system go-build-system)
   (arguments
    '(#:tests? #f
      #:import-path "github.com/tscholl2/siec"))
   (home-page "https://github.com/tscholl2/siec")
   (synopsis "siec")
   (description "Super-Isolated Elliptic Curve Implementation in Go")
   (license license:expat)))

(define-public go-github-com-schollz-croc
  (package
    (name "go-github-com-schollz-croc")
    (version "9.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/schollz/croc")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0yh27apiggaczb7k52nrzhy3skh43mcb168m7di0b0j6lnnmbagx"))))
    (build-system go-build-system)
    (arguments
     '(#:tests? #f
       #:import-path "github.com/schollz/croc"))
    (native-inputs `(("go-gopkg-in-yaml-v3" ,go-gopkg-in-yaml-v3)
                     ("go-gopkg-in-check-v1" ,go-gopkg-in-check-v1)
                     ("go-golang-org-x-text" ,go-golang-org-x-text)
                     ("go-golang-org-x-term" ,go-golang-org-x-term)
                     ("go-golang-org-x-sys" ,go-golang-org-x-sys)
                     ("go-github-com-twmb-murmur3" ,go-github-com-twmb-murmur3)
                     ("go-github-com-tscholl2-siec" ,go-github-com-tscholl2-siec)
                     ("go-github-com-spaolacci-murmur3" ,go-github-com-spaolacci-murmur3)
                     ("go-github-com-russross-blackfriday" ,go-github-com-russross-blackfriday)
                     ("go-github-com-rivo-uniseg" ,go-github-com-rivo-uniseg)
                     ("go-github-com-pmezard-go-difflib" ,go-github-com-pmezard-go-difflib)
                     ("go-github-com-mitchellh-colorstring" ,go-github-com-mitchellh-colorstring)
                     ("go-github-com-mattn-go-runewidth" ,go-github-com-mattn-go-runewidth)
                     ("go-github-com-magisterquis-connectproxy" ,go-github-com-magisterquis-connectproxy)
                     ("go-github-com-davecgh-go-spew" ,go-github-com-davecgh-go-spew)
                     ("go-github-com-cpuguy83-go-md2man" ,go-github-com-cpuguy83-go-md2man)
                     ("go-github-com-oneofone-xxhash" ,go-github-com-oneofone-xxhash)
                     ("go-golang-org-x-time" ,go-golang-org-x-time)
                     ("go-golang-org-x-net" ,go-golang-org-x-net)
                     ("go-golang-org-x-crypto" ,go-golang-org-x-crypto)
                     ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                     ("go-github-com-schollz-mnemonicode" ,go-github-com-schollz-mnemonicode)
                     ("go-github-com-schollz-progressbar-v3" ,go-github-com-schollz-progressbar-v3)
                     ("go-github-com-schollz-peerdiscovery" ,go-github-com-schollz-peerdiscovery)
                     ("go-github-com-schollz-pake" ,go-github-com-schollz-pake)
                     ("go-github-com-schollz-logger" ,go-github-com-schollz-logger)
                     ("go-github-com-schollz-cli" ,go-github-com-schollz-cli)
                     ("go-github-com-kalafut-imohash" ,go-github-com-kalafut-imohash)
                     ("go-github-com-denisbrodbeck-machineid" ,go-github-com-denisbrodbeck-machineid)
                     ("go-github-com-chzyer-readline" ,go-github-com-chzyer-readline)
                     ("go-github-com-cespare-xxhash" ,go-github-com-cespare-xxhash)))
    (home-page "https://github.com/schollz/croc")
    (synopsis "Install")
    (description
     "This project is supported by @@url{https://github.com/sponsors/schollz,Github
sponsors}.")
    (license license:expat)))

(define-public croc go-github-com-schollz-croc)
