-- Personal input overrides on top of Omarchy's defaults
-- (/usr/share/omarchy/default/hypr/input.lua). Symlinked to
-- ~/.config/hypr/input.lua by os/omarchy.sh. Hyprland reloads on save.

hl.config({
  input = {
    -- CapsLock = Control (same as Karabiner on macOS). This replaces Omarchy's
    -- "omarchy:shift_caps_compose", so Shift+CapsLock is no longer Compose.
    kb_options = "ctrl:nocaps",

    -- Close to macOS InitialKeyRepeat=15 (225ms) / KeyRepeat=2 (30ms ≈ 33/s).
    -- Omarchy's default rate (40/s) is already a bit faster, so keep it.
    repeat_delay = 225,
    repeat_rate = 40,
  },
})
