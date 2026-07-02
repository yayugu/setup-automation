bindkey -e # emacsライクなキーバインド

export EDITOR=vim
export LANG=C.UTF-8

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

# 矢印↑↓も前方一致の履歴検索に (omzと同じcontrib widget。カーソルはprefix末尾に残る。
#  複数行編集中は行移動として振る舞う)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search

# Home/End/Delete: 素のzshのemacsキーマップでは未バインド (いままではomzが担当)
bindkey "^[[H" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[OH" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[4~" end-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char

# プロンプト: oh-my-zsh robbyrussellテーマの判定ロジックを移植 (外部依存なし)
#   ➜  dir git:(branch) ✗     矢印は直前コマンド成功で緑/失敗で赤
#   ✗ = staged/unstaged/untracked いずれかの変更あり (omzと同一の判定)
setopt prompt_subst
_git_prompt_info() {
  local ref
  ref=$(git symbolic-ref --short HEAD 2>/dev/null) ||
    ref=$(git rev-parse --short HEAD 2>/dev/null) || return 0
  ref=${ref//\%/%%}
  local dirty=''
  [ -n "$(git status --porcelain 2>/dev/null | head -c1)" ] && dirty=' %F{yellow}✗%f'
  print -r -- " %F{blue}git:(%F{red}${ref}%F{blue})%f${dirty}"
}
PROMPT='%B%(?.%F{green}.%F{red})➜%f  %F{cyan}%c%f$(_git_prompt_info)%b '

# ターミナルタイトルにカレントディレクトリを表示
autoload -Uz add-zsh-hook
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
