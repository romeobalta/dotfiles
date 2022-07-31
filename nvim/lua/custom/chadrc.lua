-- Just an example, supposed to be placed in /lua/custom/

local M = {}
local override = require("custom.override")

-- make sure you maintain the structure of `core/default_config.lua` here,
-- example of changing theme:

M.ui = {
	theme = "gruvbox",
	theme_toggle = { "gruvbox", "gruvbox_light" },
	transparency = true,
}

M.plugins = {
	override = {
		["kyazdani42/nvim-tree.lua"] = override.nvimtree,
		["nvim-treesitter/nvim-treesitter"] = override.treesitter,
		["lukas-reineke/indent-blankline.nvim"] = override.blankline,
		["williamboman/mason"] = override.mason,
		["hrsh7th/nvim-cmp"] = override.cmp,
	},

	user = require("custom.plugins"),
}

M.mappings = require("custom.mappings")

_G.append = function()
	vim.api.nvim_feedkeys("`]a", "n", false)
end

_G.prepend = function()
	vim.api.nvim_feedkeys("`[i", "n", false)
end

return M
