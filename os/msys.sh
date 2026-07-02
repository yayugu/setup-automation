#!/usr/bin/env bash
# MSYS2 setup. Run from an MSYS2 shell.
#   ./os/msys.sh
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../lib/common.sh"
source "$DIR/../lib/symlinks.sh"

log "pacman sync + install packages"
pacman -Syu --noconfirm --needed $(pkglist msys.pkglist)

ensure_canonical_repo      # git now present: clone ~/setup-automation, repoint REPO_ROOT
ensure_oh_my_zsh
ensure_git2
setup_symlinks

print_manual_steps
print_bootstrap_cleanup
