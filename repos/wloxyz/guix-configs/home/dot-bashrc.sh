eval "$(direnv hook bash)"
eval "$(zoxide init bash)"

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"

# provide integration for emacs' `eat` terminal
[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  source "$EAT_SHELL_INTEGRATION_DIR/bash"

# makeshift version of nixos' comma package
function , {
    guix shell $1 -- $1
}
