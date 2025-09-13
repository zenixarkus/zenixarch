#
# ~/.bashrc
#

[[ $- != *i* ]] && return
[[ "$(whoami)" = "root" ]] && return
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100

# Add ~/.zenixarch/bin to PATH
PATH="$HOME/.zenixarch/bin:$PATH"

# zsh who?
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Make the bash history file functionally infinite and sync terminal history
shopt -s histappend
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000

# Easy un/mounting of my external SSD
alias mssd='doas cryptsetup open /dev/sda3 cryptext && doas mount /dev/mapper/cryptext /mnt'
alias ussd='doas umount -R /mnt && doas cryptsetup close cryptext'

# Ease transition to doas
alias sudo='doas'

# Sane command defaults
alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias ls='ls -lha --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias clear='clear && ls'

cd() {
    builtin cd "$@" && ls
}

# Extract archive based on file type
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz)    tar xvzf "$1" ;;
            *.tgz)       tar xvzf "$1" ;;
            *.tar.xz)    tar xvJf "$1" ;;
            *.tar)       tar xvf "$1" ;;
            *.zip)       doas pacman -S unzip && unzip "$1" && doas pacman -Rcns unzip ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    fi
}
