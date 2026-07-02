#!/usr/bin/env bash
# Common helpers sourced by every os/*.sh script.
# POSIX-bash. No secrets. Safe to re-run (idempotent).

set -euo pipefail

# Repo root = parent dir of this lib/ directory (i.e. wherever this script was
# invoked from — may be the throwaway bootstrap tarball dir setup-automation-main).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT
INVOKED_FROM="$REPO_ROOT"   # remembered so we can tell the user to delete it later

# Canonical, git-backed checkout. All persistent symlinks point here (never at the
# bootstrap dir), so you can edit/commit dotfiles after setup.
CANON_DIR="$HOME/setup-automation"
CANON_HTTPS="https://github.com/yayugu/setup-automation.git"
CANON_SSH="git@github.com:yayugu/setup-automation.git"
GIT2_SSH="git@github.com:yayugu/git2.git"

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

# --- canonical repo ----------------------------------------------------------
# Ensure a git-backed checkout exists at ~/setup-automation, then repoint
# REPO_ROOT at it so every later step (symlinks, karabiner, brew, pkglists) uses
# the persistent clone rather than the disposable bootstrap dir. Requires git
# (installed by the os script's package step before this is called). Repo is
# public, so the clone needs no ssh key; origin is switched to ssh for pushing.
ensure_canonical_repo() {
  if [ -d "$CANON_DIR/.git" ]; then
    log "canonical repo present at $CANON_DIR"
  else
    log "cloning canonical repo -> $CANON_DIR (public https, no key needed)"
    git clone "$CANON_HTTPS" "$CANON_DIR"
    git -C "$CANON_DIR" remote set-url origin "$CANON_SSH"   # push via ssh once key exists
  fi
  REPO_ROOT="$CANON_DIR"
}

# Tell the user the bootstrap dir is disposable (only if we didn't run from the
# canonical clone in the first place).
print_bootstrap_cleanup() {
  [ "$INVOKED_FROM" = "$CANON_DIR" ] && return
  printf '\n\033[1;36mBootstrap done. Canonical git repo: %s\033[0m\n' "$CANON_DIR"
  printf 'This bootstrap dir is no longer needed — delete it:\n    rm -rf %q\n' "$INVOKED_FROM"
}

# --- git2 (private helper repo; cloned into the canonical checkout) -----------
# Best-effort over ssh. On a fresh machine without a key this fails gracefully
# and is queued as a manual step. Call after ensure_canonical_repo.
ensure_git2() {
  local dir="$CANON_DIR/git2"
  if [ -e "$dir" ]; then log "git2 already present"; return; fi
  log "cloning git2 (private, over ssh)"
  if git clone "$GIT2_SSH" "$dir" 2>/dev/null; then
    log "git2 cloned"
  else
    warn "git2 clone failed — ssh key not available yet"
    manual "git2: 鍵が使えるようになったら  git clone $GIT2_SSH $dir"
  fi
}

# --- package list reader -----------------------------------------------------
# Prints package names from packages/<name>, skipping blanks and # comments.
pkglist() {
  local f="$REPO_ROOT/packages/$1"
  [ -f "$f" ] || die "package list not found: $f"
  grep -vE '^\s*(#|$)' "$f"
}
