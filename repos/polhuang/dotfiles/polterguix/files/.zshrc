# on guix systems, go to ~/.config/zsh/ and delete the cache to reconfigure if using a package manager.

# load private key into keychain
eval "$(keychain --eval --quiet id_ed25519)"

# history
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS

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

# word characters are alphanumeric characters only
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

TMOUT=600

TRAPALRM() {
    asciiquarium
}

# aliases
alias ll="eza -lah --icons --group-directories-first"
alias ls="eza -la --icons --git"
alias cat="bat"
alias less="bat --paging=always"
alias config="cd ~/.config/"
alias dotfiles="cd ~/.dotfiles/"
alias dl="cd ~/Downloads/"
alias docs="cd ~/Documents/"
alias vim="nvim"

# zoxide
eval "$(zoxide init zsh)"

# starship
# use starship only in kitty
# since starship causes formatting errors in eat (terminal emulator)

if [[ "$TERMINFO" == */elpa/eat-*/terminfo ]]; then
    PROMPT="🦂 [eat] > %~ > "
else
    eval "$(starship init zsh)"
fi 
    
# bun
export BUN_INSTALL="$HOME/.bun" 
export PATH="$BUN_INSTALL/bin:$PATH" 

# ghostty

if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi
