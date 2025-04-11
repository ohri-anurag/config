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

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
export VISUAL="nvim"

eval "$(fzf --bash)"

alias ga='git add'
alias gap='git add --patch'
alias gb='git branch'
alias gc='git commit -S -m'
alias gca='git commit -S --amend'
alias gcb='git checkout -b'
alias gd='GIT_EXTERNAL_DIFF=difft git diff'
alias gdt='git difftool -y'
alias gds='GIT_EXTERNAL_DIFF=difft git diff --staged'
alias gmt='git mergetool'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gplm='git pull -S origin master'
alias gplr='git pull --recurse-submodules'
alias gpu='git push --set-upstream origin "$(git symbolic-ref --short HEAD)"'
alias grc='git rebase --continue'
alias gri='git rebase -i'
alias grs='git rebase --skip'
alias gra='git rebase --abort'
alias gst='git status'
alias v=nvim

replace() {
  rg -l -F $1 . | xargs sed -i s/$1/$2/g
}

# If there is .bashenv.sh file in the directory where the terminal is started, this will load it.
if [ -f .bashenv.sh ]; then
  source .bashenv.sh
fi
function cd() {
  # If there is .bashenv.sh file in the directory being `cd`ed, this will load it.
  builtin cd "$@" || return
  if [ -f .bashenv.sh ]; then
    source .bashenv.sh
  fi
}

TASKS_FILE=~/tasks.json
function task() {
  DESC=$(gum input --placeholder "What needs doing?")
  DUESTR=$(gum input --placeholder "When is it due?")
  DUE=$(date -u -d "$(date -d "$DUESTR")" +"%Y-%m-%dT%H:%M:%SZ")
  N=$(jq 'map(.id) | max' $TASKS_FILE)
  if [[ $N -eq 100 ]]
  then
    N=1
  else
    N=$((N + 1))
  fi
  TASK='{"id": '$N', "desc": "'$DESC'", "due": "'$DUE'"}'
  if [[ -z "$DESC" || -z "$DUE" ]]
  then
    echo "Need both description and due date"
    return
  fi
  jq '. += ['"$TASK"'] | sort_by(.due | fromdate)' $TASKS_FILE > ~/tasks.json.tmp
  mv ~/tasks.json.tmp $TASKS_FILE
}

function tasks() {
  N=$(jq 'length' $TASKS_FILE)
  if [[ $N -eq 0 ]]
  then
    echo "$(gum style --foreground 120 "You don't have any tasks left!! Hooray!!")"
    return
  fi
  HEADER_DATE=$(gum style --padding="0 4" --foreground 167 --border normal --border-foreground 167 "Date")
  HEADER_DESC=$(gum style --padding="0 15" --foreground 104 --border normal --border-foreground 104 "Description")
  HEADER_ID=$(gum style --padding="0 1" --foreground 115 --border normal --border-foreground 115 "ID")
  HEADER=$(gum join "$HEADER_DATE" "$HEADER_DESC" "$HEADER_ID")
  echo "$HEADER"
  jq '.[]' -c $TASKS_FILE | while read task; do
    DATE=$(date +"%d %b %Y" -d "$(echo $task | jq -r '.due')" | gum style --padding="0 1" --foreground 167 --border none --border-foreground 167)
    DESC=$(echo $task | jq -r '.desc' | gum style --width 41 --foreground 104 --margin="0 0 0 2")
    ID=$(echo $task | jq -r '.id' | gum style --width 5 --margin="0 0 0 2" --foreground 115)
    echo "$(gum join "$DATE" "$DESC" "$ID")"
  done
}

function finished() {
  if [[ -z "$1" ]]
  then
    echo "Need an ID to mark a task as finished"
    return
  fi
  jq 'map(select(.id != '$1'))' $TASKS_FILE > ~/tasks.json.tmp
  mv ~/tasks.json.tmp $TASKS_FILE
}

function notify() {
  ~/notify.sh
}

function start() {
  case $1 in
    "break")
      PROJECT_ID=209847916
      COLOR=134
      ;;
    "impl")
      PROJECT_ID=209534029
      COLOR=61
      ;;
    "inv")
      PROJECT_ID=209534030
      COLOR=32
      ;;
    "learn")
      PROJECT_ID=209534031
      COLOR=172
      ;;
    "meet")
      PROJECT_ID=209538618
      COLOR=160
      ;;
    "pair")
      PROJECT_ID=209561028
      COLOR=34
      ;;
    *)
      echo "Need a valid project name"
      return
      ;;
  esac
  toggl start --project "$PROJECT_ID" --workspace 9258696 "$2"
  if [[ $? -eq 0 ]]
  then
    echo "$(gum style --foreground  "$COLOR" "$2" --border normal --border-foreground "$COLOR")"
    return
  fi
}

function stop() {
  toggl stop
}

export OPENAI_API_KEY="$(cat ~/.openaikey)"
