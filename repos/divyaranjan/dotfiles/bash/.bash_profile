#
# ~/.bash_profile
#

# Set up Guix Home profile
if [ -f ~/.profile ]; then . ~/.profile; fi

# Honor per-interactive-shell startup file
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

source ~/.config/shell/profile

# Merge search-paths from multiple profiles, the order matters.
eval "$(guix package --search-paths \
-p $HOME/.config/guix/current \
-p $HOME/.guix-home/profile \
-p $HOME/.guix-profile \
-p /run/current-system/profile)"

# Prepend setuid programs.
export PATH=/run/setuid-programs:$PATH

# Correct path for SSL certificates
# export SSL_CERT_DIR="/etc/ssl/certs"

# emacs --daemon
