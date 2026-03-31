local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.default_prog = { "wsl.exe", "-d", "Ubuntu" }
config.window_close_confirmation = 'NeverPrompt'
-- config.font = wezterm.font_with_fallback({ "JetBrainsMono Nerd Font", "Cascadia Code PL" })
config.font_size = 12.0
config.line_height = 1.05
config.color_scheme = "Builtin Solarized Dark"
config.window_background_opacity = 0.96
config.window_decorations = "RESIZE"
-- config.use_fancy_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true

-- TUI compatibility in WSL: use WezTerm's native TERM and avoid CSI-u key mode.
config.term = "wezterm"
config.enable_csi_u_key_encoding = false

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
}

config.launch_menu = {
  { label = "WSL Ubuntu", args = { "wsl.exe", "-d", "Ubuntu" } },
  { label = "PowerShell", args = { "pwsh.exe", "-NoLogo" } },
  { label = "Git Bash", args = { "C:/Program Files/Git/bin/bash.exe", "-i", "-l" } },
}

return config
