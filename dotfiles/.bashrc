#
# ~/.bashrc
#

[[ $- != *i* ]] && return
[[ "$(whoami)" = "root" ]] && return
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

shopt -s autocd
shopt -s histappend

export PATH="$HOME/.zenixarch/bin:$PATH"
export PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000

alias mssd='doas cryptsetup open /dev/sda3 cryptext && doas mount /dev/mapper/cryptext /mnt'
alias ussd='doas umount -R /mnt && doas cryptsetup close cryptext'

alias sudo='doas'

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias ls='ls -lha --color=auto --group-directories-first'
alias grep='grep --color=auto'

cd() {
    builtin cd "$@" && ls
}

extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.gz)    tar xvzf "$1" ;;
            *.tgz)       tar xvzf "$1" ;;
            *.tar.xz)    tar xvJf "$1" ;;
            *.tar)       tar xvf "$1" ;;
            *.zip)       doas pacman -S --noconfirm unzip && unzip "$1" && doas pacman -Rcns --noconfirm unzip ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    fi
}
