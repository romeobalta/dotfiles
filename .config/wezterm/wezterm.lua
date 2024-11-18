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
	-- { family = "Berkeley Mono" },
	{ family = "JetBrains Mono", weight = "DemiBold" },
	"nonicon",
})
config.font_size = 24
config.front_end = "OpenGL"
-- config.freetype_load_flags = "NO_HINTING"
-- config.freetype_load_target = "Light"
-- config.freetype_render_target = "HorizontalLcd"
config.cell_width = 0.9
-- config.harfbuzz_features = { "ss02" }

config.color_scheme = "Tokyo Night"

-- and finally, return the configuration to wezterm
return config
