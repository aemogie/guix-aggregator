# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob notify
unsetopt autocd beep nomatch
bindkey -v

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$ZDOTDIR/.zshrc'

autoload -Uz compinit
compinit

autoload -Uz promptinit
promptinit
prompt redhat
# End of lines added by compinstall

# eval "$(starship init zsh)"

source "$GUIX_PROFILE/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$GUIX_PROFILE/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Configure pinentry to use the correct TTY
gpg-connect-agent updatestartuptty /bye >/dev/null
