# setup-automation

One-shot environment setup for a fresh machine. **Public repo, zero secrets.**

Design goals: fetch without git or an SSH key (public tarball), install everything scriptable,
and collect the irreducible interactive steps into one checklist (`MANUAL.md`).

## Bootstrap (no git / no SSH key required)

`curl` and `tar` ship with macOS, Windows 10+, and most Linux — that's all you need to start.
The extracted `setup-automation-main/` dir is a **throwaway bootstrap** — the script re-clones a
proper git checkout to `~/setup-automation` and points everything there (see below).

```sh
# macOS / Linux / MSYS2
curl -fsSL https://github.com/yayugu/setup-automation/archive/refs/heads/main.tar.gz | tar xz
cd setup-automation-main
```

Then run the script for your platform (you pick it — no auto-detection):

```sh
./os/mac.sh        # macOS (GUI: brew, Xcode, Karabiner, Enpass, Firefox, Claude/Codex...)
./os/arch.sh       # Arch (WSL / server, CLI only)
./os/debian.sh     # Debian / Ubuntu (CLI only)
./os/msys.sh       # MSYS2 (run from an MSYS2 shell)
```

```powershell
# Windows (PowerShell)
irm https://github.com/yayugu/setup-automation/archive/refs/heads/main.zip -OutFile sa.zip
Expand-Archive sa.zip -DestinationPath .
cd setup-automation-main
powershell -ExecutionPolicy Bypass -File .\os\windows.ps1
```

Each script installs git + packages, then **clones the canonical repo to `~/setup-automation`**
(public HTTPS, no key needed; `origin` is switched to SSH so you can push once your key is present)
and symlinks dotfiles **into that clone** — so you can edit and commit them afterwards. It also
clones oh-my-zsh and, on macOS/Windows, sets up GUI apps. Existing/stale symlinks (e.g. old
`~/environment` ones) are overwritten via `ln -sfn`.

When it finishes it prints a line telling you the bootstrap dir is disposable:

```sh
rm -rf setup-automation-main     # the git checkout at ~/setup-automation is the real one
```

Anything that needs a human (Enpass activation, Karabiner security approvals, Firefox Sync
sign-in, etc.) is printed at the end and listed in [MANUAL.md](MANUAL.md).

## Layout
```
os/         per-OS entry scripts (run one manually)
lib/        common.sh (helpers, symlink, manual-step queue) + symlinks.sh
packages/   Brewfile + *.pkglist (plain newline lists)
gui/        karabiner/
home/       dotfiles (.gitconfig has NO token — use `gh auth login`)
MANUAL.md   interactive/GUI steps that can't be scripted
```

## Secrets
None live here, and nothing here depends on a secret to run. Never commit a secret to this repo.

## After bootstrap
`~/setup-automation` is your git checkout (origin already set to SSH — push works once your key is
present). To also fetch the private git2 helper repo:
```sh
git clone git@github.com:yayugu/git2.git ~/setup-automation/git2
```
