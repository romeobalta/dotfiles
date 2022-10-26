local M = {}

M.colours = {
	base_30 = {
		black = "#262626",
		statusline_bg = "#262626",
		line = "#7c6f64",
		grey = "#7c6f64",
		grey_fg = "#7c6f64",
	},
}

M.hl_add = {
	St_gitIcons_added = {
		fg = "green",
	},

	St_gitIcons_changed = {
		fg = "yellow",
	},

	St_gitIcons_removed = {
		fg = "red",
	},
}

M.hl_override = {
	St_EmptySpace = {
		fg = "lightbg",
	},

	-- St_EmptySpace2 = {
	-- 	fg = "black",
	-- 	bg = "black",
	-- },

	St_NormalModeSep = {
		bg = "lightbg",
	},
}

return M
