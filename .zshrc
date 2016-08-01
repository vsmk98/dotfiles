# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

alias vpn="sshuttle -r root@128.199.196.187 0.0.0.0/0"
alias t="tmux a -t 0"

# pyenv setting
export PATH=/usr/local/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# alias brew="env PATH=${PATH/\/Users\/Zekun\/\.pyenv\/shims:/} brew"
alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"

# emacs support
if [ -n "$INSIDE_EMACS" ]; then
    # chpwd() { print -P "\033AnSiTc %d" }
    # print -P "\033AnSiTu %n"
    # print -P "\033AnSiTc %d"
    ZSH_THEME="agnoster"
else
    ZSH_THEME="agnoster"
fi

# fuck
alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# Matlab
export PATH=$PATH:/Applications/MATLAB_R2014b.app/bin

# WEKA
export CLASSPATH=/Applications/weka-3-6-12-oracle-jvm.app/Contents/Java/weka.jar:$CLASSPATH

# OPAM configuration
. /Users/Derek/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# lib
export LD_LIBRARY_PATH="/usr/local/lib"
