# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
[ -f /etc/bashrc ] && source /etc/bashrc

# prompt
# PS0="\e[2 q"
# PS1="\n\[\e[1;32m\]\w\n\[\e[1;33m\]λ\[\e[m\] "

# tab complete cycling
# bind "TAB:menu-complete"
# bind "set show-all-if-ambiguous on"
# bind "set menu-complete-display-prefix on"
