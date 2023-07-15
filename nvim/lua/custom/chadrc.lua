-- Just an example, supposed to be placed in /lua/custom/
local M = {}

local gruvbox = require("custom.themes.gruvbox")

M.ui = {
	changed_themes = {
		gruvbox = gruvbox.colours,
	},

	hl_add = gruvbox.hl_add,
	hl_override = gruvbox.hl_override,

	theme = "gruvbox",
	transparency = true,
}

M.plugins = require("custom.plugins")

M.mappings = require("custom.mappings")

_G.append = function()
	vim.api.nvim_feedkeys("`]a", "n", false)
end

_G.prepend = function()
	vim.api.nvim_feedkeys("`[i", "n", false)
end

return M
