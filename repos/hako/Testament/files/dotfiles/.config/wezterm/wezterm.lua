local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- This improves input latency in my environment.
config.enable_wayland = false

config.window_background_opacity = 0.97
config.color_scheme = 'Catppuccin Mocha'

return config
