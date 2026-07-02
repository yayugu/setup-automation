bindkey -e                        # emacsライクなキーバインド

export EDITOR=vi                  # エディタはvi
export LANG=C.UTF-8               # メッセージ英語・POSIXソート順(意図的)

# 補完
autoload -Uz compinit; compinit
setopt list_packed                # リストを詰めて表示
setopt list_types                 # 補完一覧ファイル種別表示
zstyle ':completion:*' menu select                   # 候補をカーソルで選択
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # 小文字入力で大文字にもマッチ
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# ディレクトリ移動
setopt autopushd                  # cdの履歴を保持 (cd -<Tab>)
setopt pushd_ignore_dups          # 同ディレクトリを履歴に追加しない
setopt auto_cd                    # ディレクトリ名だけで移動

# 履歴
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups           # 直前と同じコマンドは記録しない
setopt hist_ignore_space          # 先頭スペースのコマンドは記録しない
setopt hist_reduce_blanks         # 余分なスペースを詰めて記録
setopt share_history              # 履歴をセッション間で共有
setopt extended_history           # 実行時刻・所要時間も記録

# history 操作まわり
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# プロンプト: robbyrussell風 (zsh組み込みのvcs_infoのみ、外部依存なし)
#   ➜  dir git:(branch) ✗     矢印は直前コマンド成功で緑/失敗で赤
#   ✗=未ステージ変更 ✚=ステージ済み変更 (untrackedファイルは検出しない)
autoload -Uz vcs_info add-zsh-hook
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %F{yellow}✗%f'
zstyle ':vcs_info:git:*' stagedstr ' %F{yellow}✚%f'
zstyle ':vcs_info:git:*' formats ' %F{blue}git:(%F{red}%b%F{blue})%f%u%c'
zstyle ':vcs_info:git:*' actionformats ' %F{blue}git:(%F{red}%b|%a%F{blue})%f%u%c'
add-zsh-hook precmd vcs_info
PROMPT='%B%(?.%F{green}.%F{red})➜%f  %F{cyan}%c%f${vcs_info_msg_0_}%b '

# ターミナルタイトルにカレントディレクトリを表示
case $TERM in
  xterm*|rxvt*|tmux*|screen*)
    _set_title() { print -Pn '\e]0;%~\a' }
    add-zsh-hook precmd _set_title
    ;;
esac

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
alias gdf="git diff"
alias gsub="git submodule update --init --recursive"
alias tu="tmux -u"
alias v="vi"

# less command color support
export LESS='-R'

# git2 (private repo, cloned separately after ssh key is available)
[ -d ~/setup-automation/git2/bin ] && export PATH=$PATH:~/setup-automation/git2/bin

[ -f ~/.zshrc.mac ] && source ~/.zshrc.mac
[ -f ~/.zshrc.my ] && source ~/.zshrc.my

# 入力支援プラグイン (setupスクリプトが ~/.zsh に clone。無ければ黙ってスキップ)
[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# syntax-highlighting は他のzle設定より後 = .zshrc の最後で source する決まり
[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
