# Lines configured by zsh-newuser-install
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob notify
unsetopt autocd beep nomatch
bindkey -v

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '$ZDOTDIR/.zshrc'

autoload -Uz compinit
# Completion files: Use XDG dirs
[ -d "$XDG_CACHE_HOME"/zsh ] || mkdir -p "$XDG_CACHE_HOME"/zsh
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-$ZSH_VERSION

autoload -Uz promptinit && promptinit
prompt redhat
# End of lines added by compinstall

# eval "$(starship init zsh)"

source "$HOME/.guix-home/profile/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.guix-home/profile/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Configure pinentry to use the correct TTY
gpg-connect-agent updatestartuptty /bye >/dev/null
