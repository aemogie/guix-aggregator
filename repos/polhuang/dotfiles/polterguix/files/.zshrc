# history
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# autocompletion
autoload -Uz compinit
compinit
zstyle ':completion:*' format 'Presenting the compleat and unabridged %d'
zstyle ':completion:*' list-prompt '%S%F{blue} %p: %f%k'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*:default' menu select=1

# emacs bindings
bindkey -e
bindkey "^[[3~" delete-char

# env variables
export PATH="$PATH:$HOME/.local/bin"
# export PATH="$PATH:$HOME/.nix-profile/bin"
export PATH="$PATH:$HOME/.bin"


# on guix systems, go to ~/.config/zsh/ and delete the cache to reconfigure if using a package manager. avoiding here.

TMOUT=600

TRAPALRM() {
    asciiquarium
}

# aliases
alias ll="ls -alh --color=auto"
alias ls="ls -aF --color=auto"
alias config="cd ~/.config/"
alias dotfiles="cd ~/.dotfiles/"
alias dl="cd ~/Downloads/"
alias docs="cd ~/Documents/"
alias vim="nvim"

# starship
# use starship only in kitty
# since starship causes formatting errors in eat (terminal emulator)
if [[ "$TERM" == "xterm-kitty" ]]; then
    eval "$(starship init zsh)"
else
    PROMPT="🦂 [eat] > %~ > "
fi
