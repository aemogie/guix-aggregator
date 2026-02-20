# fix pinentry tty things
export GPG_TTY=$(tty)

# set prompt
# https://bash-prompt-generator.org
PS1='\n\w\n\t \u@\H% '

# aliases
alias grep="grep --color=auto"
alias ls="ls -Ahlp --color=auto"
alias md="monerod --prune-blockchain --detach --non-interactive --hide-my-port --no-igd --no-zmq --rpc-bind-ip 10.0.0.1 --confirm-external-bind"
alias hr="gr home"
alias hrs="gr home no-substitutes"
alias sr="sudo -E gr system"
alias srs="sudo -E gr system no-substitutes"
alias dots="stow --dotfiles -t $HOME -d $HOME/src dotfiles"
alias wu="sudo herd start wireguard-wg0"
alias wd="sudo herd stop wireguard-wg0"
alias wr="sudo herd restart wireguard-wg0"
alias ip="ip --color"
