;;; SPDX-FileCopyrightText: 2023, 2024 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (testament packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build-system emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages video)
  #:use-module (nongnu packages video)
  #:use-module (rosenthal packages rust-apps))


;;;
;;; Packages
;;;

(define-public emacs-eshell-atuin
  (let ((commit "1ac4895529546839985c7f57c9858644f7be1e6a")
        (revision "0"))
    (package
      (name "emacs-eshell-atuin")
      (version (git-version "0.2.0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/SqrtMinusOne/eshell-atuin")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "0zf62qdmqw7y7s1dg3d35abr9jaymyqfbrv4bplkrry2wwk0m4gx"))))
      (build-system emacs-build-system)
      (arguments
       (list #:phases
             #~(modify-phases %standard-phases
                 (add-after 'unpack 'fix-paths
                   (lambda* (#:key inputs #:allow-other-keys)
                     (substitute* "eshell-atuin.el"
                       (("\\(executable-find \"atuin\"\\)")
                        (format #f "\"~a\""
                                (search-input-file inputs "bin/atuin")))))))))
      (propagated-inputs (list emacs-compat))
      (inputs (list atuin))
      (home-page "https://github.com/SqrtMinusOne/eshell-atuin")
      (synopsis "Integrate @code{eshell} with @command{atuin}")
      (description
       "This package provides functionality to store and browse @code{eshell}
history in @command{atuin}.  @code{atuin} stores shell history in a database,
which allows for having the same history across multiple shells, sessions, and
optionally across different machines.")
      (license license:gpl3+))))

(define-public emacs-isearch-mb
  (package
    (name "emacs-isearch-mb")
    (version "0.8")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://elpa.gnu.org/packages/isearch-mb-"
                           version ".tar"))
       (sha256
        (base32 "1b4929vr5gib406p51zcvq1ysmzvnz6bs1lqwjp517kzp6r4gc5y"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/astoff/isearch-mb")
    (synopsis "Control @code{isearch} from the minibuffer")
    (description
     "This Emacs package provides an alternative @code{isearch} UI based on the
minibuffer.  This allows editing the search string in arbitrary ways without any
special maneuver.  Unlike standard @code{isearch}, cursor motion commands do not
end the search.  Moreover, the search status information in the echo area and
some keybindings are slightly simplified.")
    (license license:gpl3+)))

(define-public emacs-nftables-mode
  (package
    (name "emacs-nftables-mode")
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://elpa.gnu.org/packages/nftables-mode-"
                           version ".tar"))
       (sha256
        (base32 "1wjw6n60kj84j8gj62mr6s97xd0aqvr4v7npyxwmhckw9z13xcqv"))))
    (build-system emacs-build-system)
    (home-page "https://elpa.gnu.org/packages/nftables-mode.html")
    (synopsis "Major mode for editing nftables scripts")
    (description
     "@code{nftables-mode} is an Emacs major mode for editing nftables scripts.
It currently only offers basic highlighting and primitive indentation.")
    (license license:gpl3+)))

(define-public emacs-treesit-auto
  (package
    (name "emacs-treesit-auto")
    ;; NOTE: Not tagged, also change commit when updating.
    (version "1.0.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/renzmann/treesit-auto")
             (commit "016bd286a1ba4628f833a626f8b9d497882ecdf3")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03bvam7cpxqp4idhd235n76qdqhsbgw7m2lphy8qqwslbmcq23m4"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/renzmann/treesit-auto")
    (synopsis "Automatically use tree-sitter major modes")
    (description
     "@code{treesit-auto} is an Emacs package for automatically using tree-sitter
major modes and falling back to the original major mode when its tree-sitter
counterpart is unavailable.")
    (license license:gpl3+)))

(define-public mpv/dolly
  (package
    (inherit mpv)
    (propagated-inputs '())
    (inputs
     (modify-inputs
         (append (package-propagated-inputs mpv)
                 (package-inputs mpv))
       (prepend nv-codec-headers)))))
