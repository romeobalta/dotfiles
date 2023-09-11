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

-- LSP Diagnostics Options Setup
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option("updatetime", 300)
vim.g.copilot_no_maps = true

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

return M
