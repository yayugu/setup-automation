#!/usr/bin/env bash
# Symlink dotfiles into $HOME. Idempotent + overwrites stale symlinks
# (including old ones that point at ~/environment). Sourced by os/*.sh.

setup_symlinks() {
  log "symlinking dotfiles"
  link .zshrc
  link .tmux.conf
  link .vimrc
  link .vim
  link .gemrc
  if ! git config --global --get core.editor >/dev/null; then
    git config --global core.editor vim
  fi
  link .tigrc
  mkdir -p "$HOME/tmp/vim"     # vim backup/swap/undo dir (see .vimrc)
}
