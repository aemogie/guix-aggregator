HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
bindkey -e

zstyle :compinstall filename '/home/polhuang/.zshrc'

export PATH="$PATH:/home/polhuang/.local/bin"
export PATH="$PATH:/home/polhuang/.bin"

export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale

GUIX_PROFILE="$HOME/.config/guix/current"
. "$GUIX_PROFILE/etc/profile"

GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

# # Download Znap, if it's not there yet.
[[ -r ~/.zsh/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.zsh/znap

source ~/.zsh/znap/znap.zsh  # Start Znap

znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-autosuggestions
znap source rupa/z

TMOUT=600

TRAPALRM() {
    asciiquarium
}

eval "$(starship init zsh)"

