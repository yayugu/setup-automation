# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want disable red dots displayed while waiting for completion
# DISABLE_COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git kubectl)

source $ZSH/oh-my-zsh.sh
#source $HOME/setup-automation/home/.zsh/kube-ps1.sh

#[ -f $HOME/.rvm/scripts/rvm ] && source $HOME/.rvm/scripts/rvm
#[[ -s $HOME/.nvm/nvm.sh ]] && source $HOME/.nvm/nvm.sh

bindkey -e                        # emacsライクなキーバインド

export EDITOR=vi                  # エディタはvi

autoload -Uz compinit; compinit
setopt autopushd		              # cdの履歴を表示
setopt pushd_ignore_dups          # 同ディレクトリを履歴に追加しない
setopt auto_cd                    # 自動的にディレクトリ移動
setopt list_packed 		            # リストを詰めて表示
setopt list_types                 # 補完一覧ファイル種別表示


# 履歴
HISTFILE=~/.zsh_history           # historyファイル
HISTSIZE=10000                    # ファイルサイズ
SAVEHIST=10000                    # saveする量
setopt hist_ignore_dups           # 重複を記録しない
setopt hist_reduce_blanks         # スペース排除
setopt share_history              # 履歴ファイルを共有
setopt EXTENDED_HISTORY           # zshの開始終了を記録


# history 操作まわり
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# alias
if [ `uname` = "Linux" ]; then
  alias ls="ls --color"
else
  alias ls="ls -G"
fi
alias la="ls -a"
alias ll="ls -l"
alias g="git"
alias gc="git commit"
alias gca="git commit -a"
alias gcm="git commit -m"
alias gcam="git commit -a -m"
alias gco="git checkout"
alias ggrep="git grep -n"
alias ggi="git grep -n -i"
alias gps="git push"
alias gpso="git push origin"
alias gpl="git pull"
alias glog="git log --graph --pretty='format:%C(yellow)%h%Cblue%d%Creset %s %C(white bold)%an, %ar%Creset'"
alias glgg="git log --stat --pretty=format:'%Cblue%h %Cgreen%ar %Cred%an %Creset%s %Cred%d'"
alias glg="glgg | head"
alias gst="git status -s -b"
alias gdf="git diff --color"
alias gsub="git submodule update --init --recursive"
alias gemsr="gem search -r"
alias b="bundle"
alias bi="bundle install"
alias be="bundle exec"
alias ber="bundle exec rake"
alias ru="rvm use"
alias ru193="rvm use 1.9.3"
alias ru192="rvm use 1.9.2"
alias ru18="rvm use 1.8.7"
alias tu="tmux -u"
alias v="vi"
alias vssh="vagrant ssh"
alias vup="vagrant up"
alias as="aptitude search"
alias au="sudo apt-get update"
alias ai="sudo apt-get install"
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34    ' 'cd=43;34'
kbash() { kubectl exec -it $1 bash }

# less command color support
export LESS='-R'

export PATH=/usr/local/bin:$PATH
#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#PATH=$PATH:$HOME/bin
#PATH=$PATH:$HOME/node_modules/.bin
#PATH=$PATH:/usr/local/share/npm/lib/node_modules
#PATH=$HOME/.cabal/bin:$PATH
PATH=$HOME/works/depot_tools:$PATH

# git2 (private repo, cloned separately after ssh key is available)
[ -d ~/setup-automation/git2/bin ] && export PATH=$PATH:~/setup-automation/git2/bin

export LANG=C.UTF-8;

#PROMPT=$PROMPT'$(kube_ps1)'

[ -f ~/.zshrc.mac ] && source ~/.zshrc.mac
[ -f ~/.zshrc.my ] && source ~/.zshrc.my
