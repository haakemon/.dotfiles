-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Darcula (base16)'
config.color_scheme = 'Dracula'
config.font = wezterm.font 'VictorMono Nerd Font'

-- https://github.com/wez/wezterm/issues/4483#issuecomment-1835619115
config.enable_wayland = false

-- and finally, return the configuration to wezterm
return config
