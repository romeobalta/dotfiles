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

config.font = wezterm.font_with_fallback({
	{
		family = "Berkeley Mono",
	},
	{
		family = "JetBrains Mono",
		weight = "Medium",
	},
	"nonicon",
})
config.font_size = 14
config.front_end = "WebGpu"
config.line_height = 1.1

config.color_scheme = "Tokyo Night"

-- and finally, return the configuration to wezterm
return config
