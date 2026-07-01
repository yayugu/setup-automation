# Windows setup. Run in PowerShell.
#   powershell -ExecutionPolicy Bypass -File .\os\windows.ps1
# Windows GUI construction is rare; this mainly sets up tooling.
# MSYS2 / WSL are installed here, then run os\msys.sh / os\arch.sh inside them.

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot

function Winget-Install($id) {
  Write-Host "==> winget install $id"
  winget install --exact --id $id --accept-source-agreements --accept-package-agreements -h
  if ($LASTEXITCODE -ne 0) { Write-Warning "winget $id returned $LASTEXITCODE (may already be installed)" }
}

# --- packages ----------------------------------------------------------------
$packages = @(
  'Git.Git',
  'Mozilla.Firefox',            # work profile browser
  'Mozilla.Firefox.ESR',        # private profile browser
  'Microsoft.VisualStudioCode',
  'SlackTechnologies.Slack',
  'Enpass.Enpass',
  'MSYS2.MSYS2'                 # then run os\msys.sh inside the MSYS2 shell
  # 'Anthropic.Claude'          # TODO: confirm winget id for Claude desktop
)
foreach ($p in $packages) { Winget-Install $p }

# --- Claude Code CLI (native installer, not npm) -----------------------------
Write-Host "==> installing Claude Code CLI"
try { irm https://claude.ai/install.ps1 | iex } catch { Write-Warning "claude install failed: $_" }

# --- manual checklist --------------------------------------------------------
Write-Host ""
Write-Host "======== MANUAL STEPS ========" -ForegroundColor Magenta
@(
  'Enpass: activateとvault syncのためにクラウドサービスをリンク',
  'Firefox: work / private プロファイルで Firefox Sync サインイン',
  'WSL: wsl --install / Arch を導入し os/arch.sh を実行',
  'dotfiles(zsh/vim等)は MSYS2 または WSL 内で os/msys.sh / os/arch.sh により symlink'
) | ForEach-Object { Write-Host "  - $_" }
Write-Host "==============================" -ForegroundColor Magenta
Write-Host "Details: $RepoRoot\MANUAL.md"
