autoload -U compinit promptinit
autoload -U colors && colors
compinit
promptinit
prompt off
NORMAL_PS1="%B%F{blue}%~ %(1j.[%j].)%# %b%f%k"
INSERT_PS1="%B%F{green}%~ %(1j.[%j].)%# %b%f%k"
PS1=$INSERT_PS1

# history
HISTFILE=~/.zhistory
HISTSIZE=5000
SAVEHIST=5000
setopt incappendhistory
setopt extendedhistory
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# Vi mode
zle-keymap-select () {
  case $KEYMAP in
    vicmd) PS1=$NORMAL_PS1 ;;
    viins|main) PS1=$INSERT_PS1 ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select
zle-line-init () {
  zle -K viins
}
zle -N zle-line-init
bindkey -v

# Common emacs bindings for vi mode
bindkey '\e[3~'   delete-char
bindkey '^A'      beginning-of-line
bindkey '^E'      end-of-line
bindkey '^R'      history-incremental-pattern-search-backward
# Tmux home/end
bindkey '\e[1~'      beginning-of-line
bindkey '\e[4~'      end-of-line
# Urxvt
bindkey '\e[7~'      beginning-of-line
bindkey '\e[8~'      end-of-line

# report execution time if longer than 3 sec
REPORTTIME=3

# cd
setopt correctall
setopt autocd
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# completions
zstyle ':completion:*' completer _complete _correct _approximate 
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# aliases
alias ls='ls --color=auto'
alias grep='/bin/grep --color=auto'
alias df='df -h'
alias du='du -h'
alias sudo='nocorrect sudo'
