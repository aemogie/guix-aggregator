(define-module (mrh-guix home box bash)
  #:use-module (gnu)
  #:use-module (gnu home services shells))

(define-public (box-bash-config dotfiles-dir)
  (home-bash-configuration
   (guix-defaults? #f)
   (aliases
    `(("grep" . "grep --color=auto")
      ("ip" . "ip -color=auto")
      ("ls" . "ls -halp --color=auto")
      ("mw" . "monero-wallet-cli --daemon-address=10.0.0.1:18081 --trusted-daemon")
      ("md" . "monerod --prune-blockchain --detach --non-interactive --hide-my-port --no-igd --no-zmq --rpc-bind-ip 10.0.0.1 --confirm-external-bind")
      ("hr" . ,(format #f "guix home reconfigure -L ~a ~a/mrh-guix/home/box/config.scm"  dotfiles-dir  dotfiles-dir))
      ("sr" . ,(format #f "sudo guix system reconfigure -L ~a ~a/mrh-guix/system/box.scm" dotfiles-dir dotfiles-dir))))
   (bashrc
    (list (local-file "../.bashrc" "bashrc")))))
