#!/usr/bin/env bash
# Debian / Ubuntu setup (server / WSL). No GUI.
#   ./os/debian.sh
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/../lib/common.sh"
source "$DIR/../lib/symlinks.sh"

log "apt update + install packages"
sudo apt-get update -y
sudo apt-get install -y $(pkglist debian.pkglist)

ensure_canonical_repo      # git now present: clone ~/setup-automation, repoint REPO_ROOT
ensure_git2
setup_symlinks

manual "デフォルトshellをzshに: chsh -s \$(which zsh)"
print_manual_steps
print_bootstrap_cleanup
