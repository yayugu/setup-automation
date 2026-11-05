#!/usr/bin/env bash
# Omarchy (Arch + Hyprland desktop) setup. Run after the Omarchy installer.
#   ./os/omarchy.sh
# Idempotent + safe to re-run. Packages go through Omarchy's own `omarchy pkg`
# helpers; desktop config only touches ~/.config (never /usr/share/omarchy).

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../lib/common.sh"
source "$DIR/../lib/symlinks.sh"

command -v omarchy >/dev/null 2>&1 || die "omarchy not found — use ./os/arch.sh on plain Arch"

# --- packages ----------------------------------------------------------------
install_packages() {
  log "official packages (omarchy pkg add)"
  omarchy pkg add $(pkglist omarchy.pkglist)
}

# --- Firefox (Omarchy's default browser is Chromium) ---------------------------
install_firefox() {
  if omarchy pkg present firefox; then
    log "firefox already installed"
  else
    log "installing firefox"
    omarchy install browser firefox || warn "firefox install failed"
  fi
}

# --- Hyprland input (CapsLock=Ctrl, key repeat) -------------------------------
# ~/.config/hypr/input.lua is the user-override file Omarchy seeds; replace it
# with a symlink into the repo (the original is kept as input.lua.bak).
setup_hypr_input() {
  local src="$REPO_ROOT/gui/omarchy/hypr/input.lua"
  local dest="$HOME/.config/hypr/input.lua"
  # hyprland.lua require()s this file — a dangling link breaks the whole config.
  [ -f "$src" ] || { warn "missing $src (not pushed yet?); keeping current input.lua"; return; }
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    warn "backing up real $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -sfn "$src" "$dest"
  log "linked ~/.config/hypr/input.lua (CapsLock=Control, repeat 225ms)"
  if command -v hyprctl >/dev/null 2>&1 && [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    hyprctl reload >/dev/null && hyprctl configerrors
  fi
}

# --- Claude Code CLI (native installer, same as macOS) ------------------------
install_claude() {
  if command -v claude >/dev/null 2>&1 || [ -x "$HOME/.local/bin/claude" ]; then
    log "claude CLI already installed"
  else
    log "installing Claude Code CLI (native)"
    curl -fsSL https://claude.ai/install.sh | bash || warn "claude install failed"
  fi
}

main() {
  ensure_sudo                # one password prompt for pacman
  install_packages           # git is already there on Omarchy, zsh etc. come in here
  ensure_canonical_repo      # clone ~/setup-automation, repoint REPO_ROOT
  ensure_zsh_plugins
  ensure_git2
  ensure_bun
  setup_symlinks
  setup_hypr_input
  install_firefox
  install_claude

  manual "デフォルトshellをzshに: chsh -s \$(which zsh)（Omarchy の bash 設定は ~/.bashrc に残る）"
  manual "日本語入力: fcitx5-configtool で Mozc を入力メソッドに追加（Omarchy に fcitx5-mozc は同梱）"
  manual "Enpass: スクリプト対象外（Linux 版は x86_64 のみ・AUR 不使用）。必要なら https://www.enpass.io から手動で入れて activate + vault sync"
  manual "Firefox: work / private の各プロファイルで Firefox Sync にサインイン（必要なら 'omarchy' のデフォルトブラウザ設定も変更）"
  manual "Claude: 'claude' 実行で認証"
  print_manual_steps
  print_bootstrap_cleanup
}

main "$@"
