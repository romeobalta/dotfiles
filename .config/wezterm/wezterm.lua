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
	-- "Berkeley Mono",
	{ family = "JetBrains Mono" },
	"nonicon",
})
config.font_size = 20
config.color_scheme = "Tokyo Night"
-- config.harfbuzz_features = { "ss03" }
-- config.cell_width = 0.9

-- and finally, return the configuration to wezterm
return config
