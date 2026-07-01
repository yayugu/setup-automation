#!/usr/bin/env bash
# macOS setup. Run after fetching the repo (see README bootstrap).
#   ./os/mac.sh
# Idempotent + safe to re-run. Interactive/GUI steps are collected and printed
# at the end as a manual checklist (see also MANUAL.md).

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../lib/common.sh"
source "$DIR/../lib/symlinks.sh"

# --- Xcode Command Line Tools (non-interactive) ------------------------------
# `xcode-select --install` pops a GUI dialog that blocks every time. This
# installs the CLT headlessly via softwareupdate instead.
install_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools already installed"
    return
  fi
  log "installing Xcode Command Line Tools (non-interactive)"
  local flag=/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  touch "$flag"
  local label
  label=$(softwareupdate -l 2>/dev/null \
    | grep -E 'Label: Command Line Tools' \
    | sed -E 's/.*Label: //' | sort -V | tail -n1)
  [ -n "$label" ] && softwareupdate -i "$label" --verbose || warn "CLT label not found; run: xcode-select --install"
  rm -f "$flag"
}

# --- Homebrew ----------------------------------------------------------------
install_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    log "installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then eval "$(/usr/local/bin/brew shellenv)"; fi
  log "brew bundle"
  brew bundle --file="$REPO_ROOT/packages/Brewfile" || warn "brew bundle had failures (see above)"
}

# --- Xcode (full, via mas) ---------------------------------------------------
finish_xcode() {
  if [ -d /Applications/Xcode.app ]; then
    log "accepting Xcode license + first launch"
    sudo xcodebuild -license accept || warn "xcodebuild -license accept failed"
    sudo xcodebuild -runFirstLaunch  || warn "xcodebuild -runFirstLaunch failed"
  else
    manual "App Store にサインインし 'mas install' で Xcode を取得（サインイン後 ./os/mac.sh 再実行で license accept まで自動）"
  fi
}

# --- Karabiner config (key mappings only; GUI approvals stay manual) ---------
setup_karabiner() {
  mkdir -p "$HOME/.config/karabiner"
  ln -sfn "$REPO_ROOT/gui/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
  log "linked karabiner.json (左右⌘=英かな / CapsLock=Control)"
}

# --- Claude Code CLI (native installer, not npm) -----------------------------
install_claude() {
  if command -v claude >/dev/null 2>&1; then
    log "claude CLI already installed"
  else
    log "installing Claude Code CLI (native)"
    curl -fsSL https://claude.ai/install.sh | bash || warn "claude install failed"
  fi
}

main() {
  install_clt
  install_brew
  ensure_oh_my_zsh
  setup_symlinks
  setup_karabiner
  install_claude
  finish_xcode

  # Interactive steps that cannot be scripted:
  manual "Enpass: activateとvault syncのためにクラウドサービスをリンク"
  manual "Karabiner: システム設定でドライバ(system extension)承認 + Input Monitoring / アクセシビリティを許可（TCCはスクリプト不可）"
  manual "AzooKey: cask名未確定。入力ソースとして追加・有効化（システム設定 > キーボード > 入力ソース）"
  manual "Firefox: work / private の各プロファイルで Firefox Sync にサインイン（拡張と設定が同期）"
  manual "Codex: 'codex' 実行で認証 / Claude: 'claude' 実行で認証"
  print_manual_steps
}

main "$@"
