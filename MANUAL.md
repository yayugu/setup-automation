# Manual steps

Everything here is interactive or GUI and cannot be scripted. The `os/*` scripts print the
relevant subset at the end of a run; this is the full reference.

## All GUI machines
1. **Enpass** — activate the license (enter the code emailed to you), then link another cloud service so the
   Vault syncs. Enpass is installed automatically (brew cask / winget); only activation is manual.
2. **Firefox** — sign each profile (work / private) into its own **Firefox Sync** account so
   extensions, extension settings (incl. mouse-gesture config), and bookmarks come back.
3. **Claude / Codex** — run `claude` and `codex` once to authenticate.

## macOS only
4. **Xcode** — sign into the **App Store** so `mas install` can fetch Xcode, then re-run
   `./os/mac.sh` (it will `xcodebuild -license accept` + `-runFirstLaunch` automatically).
5. **Karabiner-Elements** — approve the driver / system extension in **System Settings > Privacy &
   Security**, and grant **Input Monitoring** + **Accessibility**. These TCC approvals require
   physical clicks (not scriptable without MDM). The key mappings themselves (左右⌘=英かな,
   CapsLock=Control) are already applied via the symlinked `karabiner.json`.
6. **AzooKey** — installed via `cask "azookey"`; add & enable it under
   **System Settings > Keyboard > Input Sources**.

## Windows only
7. **WSL / MSYS2** — install the distro, then run `os/arch.sh` (WSL) or `os/msys.sh` (MSYS2)
   *inside* it to get dotfiles and CLI packages.

## Notes
- Default shell → zsh on Linux/MSYS: `chsh -s $(which zsh)`.
- `git2` (private helper repo) is cloned separately after the SSH key is available; `.zshrc` adds
  `~/setup-automation/git2/bin` to PATH only if it exists.
