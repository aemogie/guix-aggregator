#~/.bashrc

GREEN='\[\033[0;32m\]'
BLUE='\[\033[0;34m\]'
YELLOW='\[\033[0;33m\]'
RED='\[\033[0;31m\]'
PURPLE='\[\033[0;35m\]'
RESET='\[\033[0m\]'

# Function to get the current git branch
git_branch() {
    git branch 2> /dev/null | grep '*' | sed 's/* //'
}

# Function to set the prompt
set_bash_prompt() {
    # Get the current git branch
    local branch=$(git_branch)

    # Define the left part of the prompt (username, hostname, and pwd)
    local left_prompt="${GREEN}[${RESET}\u${GREEN}@${RESET}\h${GREEN}]${RESET}:${YELLOW}\w${RESET}"

    # If we are in a git repo, show the branch on the right
    if [ -n "$branch" ]; then
        local right_prompt=" [${PURPLE}${branch}${RESET}]"
    else
        local right_prompt=""
    fi

    # Set the prompt
    PS1="${left_prompt}${right_prompt}\n\$ "
}

# Activate the custom prompt
PROMPT_COMMAND=set_bash_prompt

# PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'; PS1='[\u@\h \W] ${PS1_CMD1}'

export XDG_DATA_DIR='/home/divya/.local/share/flatpak/exports/share'
#VARIABLES
export BROWSER="librewolf"
export EDITOR="emacsclient -c -t"
export VIDEO="mpv"
export MATH="/mnt/LDisk-E/Albert Einstein/Books & Resources/MIT OCW/Mathematics/"
export EINSTEIN="/mnt/LDisk-E/Albert Einstein/"
export PHIL="/mnt/LDisk-E/Albert Einstein/Books & Resources/Philosophy & Psychology/Philosophy/"
export PSYCH="/mnt/LDisk-E/Albert Einstein/Books & Resources/Philosophy & Psychology/Psychology/"
export PASSWORD_STORE_DIR="$HOME/life/passwords/pass/"

# This is the list for lf icons:
export LF_ICONS="di=📁:\
	fi=📃:\
	tw=🤝:\
	ow=📂:\
	ln=⛓:\
	or=❌:\
	ex=🎯:\
	*.txt=✍:\
	*.mom=✍:\
	*.me=✍:\
	*.ms=✍:\
	*.png=🖼:\
	*.webp=🖼:\
	*.ico=🖼:\
	*.jpg=📸:\
	*.jpe=📸:\
	*.jpeg=📸:\
	*.gif=🖼:\
	*.svg=🗺:\
	*.tif=🖼:\
	*.tiff=🖼:\
	*.xcf=🖌:\
	*.html=🌎:\
	*.xml=📰:\
	*.gpg=🔒:\
	*.css=🎨:\
	*.pdf=📚:\
	*.djvu=📚:\
	*.epub=📚:\
	*.csv=📓:\
	*.xlsx=📓:\
	*.tex=📜:\
	*.md=📘:\
	*.r=📊:\
	*.R=📊:\
	*.rmd=📊:\
	*.Rmd=📊:\
	*.m=📊:\
	*.mp3=🎵:\
	*.opus=🎵:\
	*.ogg=🎵:\
	*.m4a=🎵:\
	*.flac=🎼:\
	*.wav=🎼:\
	*.mkv=🎥:\
	*.mp4=🎥:\
	*.webm=🎥:\
	*.mpeg=🎥:\
	*.avi=🎥:\
	*.mov=🎥:\
	*.mpg=🎥:\
	*.wmv=🎥:\
	*.m4b=🎥:\
	*.flv=🎥:\
	*.zip=📦:\
	*.rar=📦:\
	*.7z=📦:\
	*.tar.gz=📦:\
	*.z64=🎮:\
	*.v64=🎮:\
	*.n64=🎮:\
	*.gba=🎮:\
	*.nes=🎮:\
	*.gdi=🎮:\
	*.1=ℹ:\
	*.nfo=ℹ:\
	*.info=ℹ:\
	*.log=📙:\
	*.iso=📀:\
	*.img=📀:\
	*.bib=🎓:\
	*.ged=👪:\
	*.part=💔:\
	*.torrent=🔽:\
	*.jar=♨:\
	*.java=♨:\
	"

##Enabling VI Mode
set -o vi


# Bindings
# bind -x '"\C-l": clear'

##PATH

if [ -d "$HOME/.bin" ] ;
then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/Applications" ] ;
then PATH="$HOME/Applications:$PATH"
fi

if [ -d "$HOME/.cabal/bin" ];
then PATH="$HOME/.cabal/bin:$PATH"
fi


##ALIASES##

alias yta='ytfzf -t -m'
alias yt='ytfzf -t'
alias cd-math='cd "/mnt/LDisk-E/Albert Einstein/Books & Resources/MIT OCW/Mathematics/"'
alias cd-einstein='cd "/mnt/LDisk-E/Albert Einstein/"'
alias cd-phil='cd "/mnt/LDisk-E/Albert Einstein/Books & Resources/Philosophy & Psychology/Philosophy/"'
alias cd-psych='cd "/mnt/LDisk-E/Albert Einstein/Books & Resources/Philosophy & Psychology/Psychology/"'

source "/home/divya/.emacs.d/straight/repos/emacs-eat/integration/bash"

# Added by Radicle.
export PATH="$PATH:/home/divya/.radicle/bin"

# Direnv
eval "$(direnv hook bash)"
