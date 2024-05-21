# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

eval "$(direnv hook bash)"

echo "Hi Anurag"
PATH="$HOME/.local/bin:$HOME/.local/bin/haskell:$PATH"
eval "$(starship init bash)"

rootDir="/home/anuragohri92/bellroy/haskell/"
build() {
  cd $rootDir
  echo "optimization: False
program-options
  ghc-options: -Wall" >cabal.project.local

  cabal --builddir=$rootDir/dist-newstyle build $1 && cabal --builddir=$rootDir/dist-newstyle test $1
}

cover() {
  cd $rootDir
  echo "optimization: False
program-options
  ghc-options: -Wall
package *
  coverage: True
  library-coverage: True

package order-processing
  coverage: False
  library-coverage: False

" >cabal.project.local

  cabal --builddir=$rootDir/dist-newstyle-cover build $1 && cabal --builddir=$rootDir/dist-newstyle-cover test $1
}

debug() {
  cd $rootDir
  echo "optimization: False
program-options
  ghc-options: -Wwarn -Wunused-top-binds -Werror=unused-top-binds" >cabal.project.local
  cabalFileName=$(ls $(awk '/^packages:$/,/^program-options$/ {print $1"/*.cabal"}' cabal.project | head -n -1 | tail -n +2 | xargs) | xargs grep "name:" | awk '{print $2"!"$1}' | grep "$1!" | awk -F"!" '{print $2}')
  dir="${cabalFileName%/*}"
  cd $dir
  if [[ $2 != "" ]]; then
    target="$1:$2"
  else
    target=$1
  fi
  ghcid -c "cabal --builddir=$rootDir/dist-newstyle-debug repl $target" -o ghcid.txt

}

buildToolsComplete() {
  local cur_word type_list

  # COMP_WORDS is an array of words in the current command line.
  # COMP_CWORD is the index of the current word (the one the cursor is
  # in). So COMP_WORDS[COMP_CWORD] is the current word
  cur_word="${COMP_WORDS[COMP_CWORD]}"
  type_list=$(ls $(awk -v rootDir="$rootDir" '/^packages:$/,/^program-options$/ {print rootDir"/"$1"/*.cabal"}' $rootDir/cabal.project | head -n -1 | tail -n +2 | xargs) | xargs grep -h "name:" | awk '{print $2}')

  # COMPREPLY is the array of possible completions, generated with
  # the compgen builtin.
  COMPREPLY=($(compgen -W "$type_list" -- "$cur_word"))
  return 0
}

# Register buildToolsComplete to provide completion for the following commands
complete -F buildToolsComplete build cover debug

source ~/.config/bash/fzf-haskell.sh

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
export VISUAL="code --wait"
alias cat='bat --paging=never'
alias grep=rg
alias find=fd
alias spot=spotify
alias cd=z
eval "$(zoxide init bash)"
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpu='git push --set-upstream origin "$(git symbolic-ref --short HEAD)"'
alias gpl='git pull'
alias gc='git commit -S -m'
alias gcb='git checkout -b'
alias gb='git branch'
alias gd='GIT_EXTERNAL_DIFF=difft git diff'
. "$HOME/.cargo/env"
