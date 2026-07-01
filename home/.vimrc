set nocompatible
filetype plugin indent on
syntax enable

set fileencodings=utf8

" 表示系
set number "行番号表示
set showmode "モード表示
set title "編集中のファイル名を表示
set ruler "ルーラーの表示
set showcmd "入力中のコマンドをステータスに表示する
set showmatch "括弧入力時の対応する括弧を表示
set laststatus=2 "ステータスラインを常に表示
set guioptions-=T "ツールバー消す
set visualbell "エラー音の代わりに画面をフラッシュ
set termguicolors
colorscheme freya

" 操作系
set formatoptions=q "指定文字数での自動改行オフ
set backspace=indent,eol,start " https://vi.stackexchange.com/questions/2162/why-doesnt-the-backspace-key-work-in-insert-mode

" プログラミングヘルプ系
set smartindent "オートインデント

" tab関連
set expandtab "タブの代わりに空白文字挿入
set shiftwidth=4
set softtabstop=4
set tabstop=4

" 検索系
set ignorecase "検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set incsearch "incremental search
set hlsearch "highlight
set magic "正規表現のエスケープを普通っぽくする"

" swap, backupファイルの置き場
set backupdir=~/tmp/vim
set backup
set directory=~/tmp/vim
set swapfile

" 終了してもundo情報を復帰できるように
set undodir=~/tmp/vim
set undofile

" キーバインド
inoremap <C-a> <Home>
noremap <C-e> <End>

" 括弧閉じとかまで一気に削除したりできるように
onoremap ) t)
onoremap ( t(
vnoremap ) t)
vnoremap ( t(
onoremap ] t]
onoremap [ t[
vnoremap ] t]
vnoremap [ t[

let mapleader = ','

" カーソルの動きを直感的(?)にする
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k
nnoremap 0 g0
nnoremap g0 0
nnoremap $ g$
nnoremap g$ $

" 最後に編集したところを選択
nnoremap gc `[v`]

" ;:入れ替え
nnoremap ; :
nnoremap : ;

" white space
set list!
set listchars=trail:_,tab:>\ 

augroup vim
  autocmd!
  autocmd FileType vim setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

augroup shellscript
  autocmd!
  autocmd FileType sh setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

augroup ruby
  autocmd!
  autocmd FileType ruby setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

augroup shellscript
  autocmd!
  autocmd FileType sh setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

augroup html
  autocmd!
  autocmd FileType html setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

augroup javascript
  autocmd!
  autocmd FileType javascript setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
augroup END

augroup cpp
  autocmd!
  autocmd FileType cpp setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=2
augroup END

function! s:at()
  let syntax = synstack(line('.'), col('.'))
  let name = empty(syntax) ? '' : synIDattr(syntax[-1], "name")
  return name =~# 'String\|Comment\|None' ? '@' : '$this->'
endfunction

augroup php
  autocmd!
  autocmd FileType php set makeprg=php\ -l\ %
  autocmd FileType php set errorformat=%m\ in\ %f\ on\ line\ %l
  autocmd FileType php inoremap <expr> <buffer> @ <SID>at()
  autocmd FileType php inoremap <C-u> ->
  autocmd FileType php inoremap <C-y> =>
  autocmd FileType php vnoremap <Leader>a :Align =><CR>
  autocmd FileType php vnoremap <Leader>? :Align ? :<CR>
  autocmd FileType php setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
augroup END
