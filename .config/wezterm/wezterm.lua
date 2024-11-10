-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.window_padding = {
	left = 6,
	right = 6,
	top = 6,
	bottom = 6,
}
config.enable_tab_bar = false
config.font_size = 18
config.color_scheme = "Tokyo Night"

-- and finally, return the configuration to wezterm
return config
