#!/usr/bin/env bash
# Arch Linux setup (WSL / server). No GUI.
#   ./os/arch.sh
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../lib/common.sh"
source "$DIR/../lib/symlinks.sh"

log "pacman sync + install official packages"
sudo pacman -Syu --noconfirm --needed $(pkglist arch.pkglist)

# AUR via yay (bootstrap yay itself if missing)
if ! command -v yay >/dev/null 2>&1; then
  log "bootstrapping yay (AUR helper)"
  sudo pacman -S --needed --noconfirm git base-devel
  tmp="$(mktemp -d)"
  git clone https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"
  ( cd "$tmp/yay-bin" && makepkg -si --noconfirm )   # makepkg must NOT run as root
  rm -rf "$tmp"
fi
log "yay install AUR packages"
yay -S --needed --noconfirm $(pkglist arch-aur.pkglist)

ensure_canonical_repo      # git now present: clone ~/setup-automation, repoint REPO_ROOT
ensure_git2
setup_symlinks

manual "デフォルトshellをzshに: chsh -s \$(which zsh)"
print_manual_steps
print_bootstrap_cleanup
