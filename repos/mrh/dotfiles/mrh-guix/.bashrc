# fix pinentry tty things
export GPG_TTY=$(tty)

# set prompt
# https://bash-prompt-generator.org
PS1='\n\w\n\t \u@\H% '

# aliases
alias grep="grep --color=auto"
alias ls="ls -Ahlp --color=auto"
alias md="monerod --prune-blockchain --detach --non-interactive --hide-my-port --no-igd --no-zmq --rpc-bind-ip 10.0.0.1 --confirm-external-bind"
alias hr="guix home reconfigure -L $HOME/src/dotfiles $HOME/src/dotfiles/mrh-guix/home/$HOSTNAME/config.scm"
alias sr="sudo guix system reconfigure -L $HOME/src/dotfiles $HOME/src/dotfiles/mrh-guix/system/$HOSTNAME/config.scm"
alias dots="stow --dotfiles -t $HOME -d $HOME/src dotfiles"
alias wu="sudo herd start wireguard-wg0"
alias wd="sudo herd stop wireguard-wg0"
alias wr="sudo herd restart wireguard-wg0"
alias ip="ip --color"
