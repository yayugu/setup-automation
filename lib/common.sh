#!/usr/bin/env bash
# Common helpers sourced by every os/*.sh script.
# POSIX-bash. No secrets. Safe to re-run (idempotent).

set -euo pipefail

# Repo root = parent dir of this lib/ directory.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT

# --- logging -----------------------------------------------------------------
log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[err]\033[0m %s\n' "$*" >&2; exit 1; }

# --- manual-step collector ---------------------------------------------------
# Steps that cannot be automated (interactive/GUI) are queued here and printed
# at the very end so the human has one checklist to work through.
MANUAL_STEPS=()
manual() { MANUAL_STEPS+=("$*"); }

print_manual_steps() {
  [ "${#MANUAL_STEPS[@]}" -eq 0 ] && { log "No manual steps. Done."; return; }
  printf '\n\033[1;35m======== MANUAL STEPS (do these by hand) ========\033[0m\n'
  local i=1
  for step in "${MANUAL_STEPS[@]}"; do
    printf '  %2d. %s\n' "$i" "$step"
    i=$((i + 1))
  done
  printf '\033[1;35m=================================================\033[0m\n'
  printf 'Full details: %s/MANUAL.md\n' "$REPO_ROOT"
}

# --- idempotent symlink ------------------------------------------------------
# link <target-under-repo-home> <dest-under-$HOME>
# Overwrites existing symlinks (e.g. old ones pointing at ~/environment).
# Refuses to clobber a real file/dir: backs it up to <dest>.bak instead.
link() {
  local target="$REPO_ROOT/home/$1"
  local dest="$HOME/${2:-$1}"
  [ -e "$target" ] || { warn "missing source: $target (skip)"; return; }

  if [ -L "$dest" ]; then
    ln -sfn "$target" "$dest"            # existing symlink -> just repoint
  elif [ -e "$dest" ]; then
    warn "backing up real $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
    ln -sfn "$target" "$dest"
  else
    ln -sfn "$target" "$dest"
  fi
  log "linked ~/${2:-$1}"
}

# --- oh-my-zsh (cloned directly; not a submodule so tarball bootstrap works) --
ensure_oh_my_zsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log "oh-my-zsh already present"
  else
    log "cloning oh-my-zsh"
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi
}

# --- package list reader -----------------------------------------------------
# Prints package names from packages/<name>, skipping blanks and # comments.
pkglist() {
  local f="$REPO_ROOT/packages/$1"
  [ -f "$f" ] || die "package list not found: $f"
  grep -vE '^\s*(#|$)' "$f"
}
