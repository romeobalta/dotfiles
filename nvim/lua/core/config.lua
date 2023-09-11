local M = {}

M.ui = {
	------------------------------- base46 -------------------------------------
	-- hl = highlights
	hl_add = {
		St_gitIcons_added = {
			fg = "green",
		},

		St_gitIcons_changed = {
			fg = "yellow",
		},

		St_gitIcons_removed = {
			fg = "red",
		},
	},
	hl_override = {
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

		NvimTreeGitDirty = {
			fg = "sun",
		},
	},
	changed_themes = {
		gruvbox = {
			base_30 = {
				black = "#262626",
				statusline_bg = "#262626",
				line = "#7c6f64",
				grey = "#7c6f64",
				grey_fg = "#7c6f64",
				one_bg2 = "#41462d",
			},

			base_16 = {
				base02 = "#686563",
			},
		},
	},
	theme_toggle = { "gruvbox", "gruvbox_light" },
	theme = "gruvbox", -- default theme
	transparency = true,
	lsp_semantic_tokens = false, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

	-- https://github.com/NvChad/base46/tree/v2.0/lua/base46/extended_integrations
	extended_integrations = {}, -- these aren't compiled by default, ex: "alpha", "notify"

	-- cmp themeing
	cmp = {
		icons = true,
		lspkind_text = true,
		style = "default", -- default/flat_light/flat_dark/atom/atom_colored
		border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
		selected_item_bg = "colored", -- colored / simple
	},

	telescope = { style = "borderless" }, -- borderless / bordered

	------------------------------- nvchad_ui modules -----------------------------
	statusline = {
		theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
		-- default/round/block/arrow separators work only for default statusline theme
		-- round and block will work for minimal theme only
		-- separator_style = "default",
		overriden_modules = function()
			return {
				git = function()
					if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
						return ""
					end

					local git_status = vim.b.gitsigns_status_dict

					local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
					local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed)
						or ""
					local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed)
						or ""
					local branch_name = "   " .. git_status.head .. " "

					return "%#St_gitIcons#"
						.. branch_name
						.. "%#St_gitIcons_added#"
						.. added
						.. "%#St_gitIcons_changed#"
						.. changed
						.. "%#St_gitIcons_removed#"
						.. removed
				end,
			}
		end,
	},

	-- lazyload it when there are 1+ buffers
	tabufline = {
		show_numbers = true,
		enabled = true,
		lazyload = true,
		overriden_modules = nil,
	},

	-- nvdash (dashboard)
	nvdash = {
		load_on_startup = false,

		header = {
			"           ▄ ▄                   ",
			"       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
			"       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
			"    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
			"  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
			"  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
			"▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
			"█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
			"    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
		},

		buttons = {
			{ "  Find File", "Spc f f", "Telescope find_files" },
			{ "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
			{ "  Bookmarks", "Spc m a", "Telescope marks" },
			{ "  Themes", "Spc t h", "Telescope themes" },
			{ "  Mappings", "Spc c h", "NvCheatsheet" },
		},
	},

	cheatsheet = { theme = "grid" }, -- simple/grid

	lsp = {
		-- show function signatures i.e args as you type
		signature = {
			disabled = false,
			silent = true, -- silences 'no signature help available' message from appearing
		},
	},
}

-- M.plugins = "" -- path i.e "custom.plugins", so make custom/plugins.lua file

M.lazy_nvim = require("plugins.configs.lazy_nvim") -- config for lazy.nvim startup options

M.mappings = require("core.mappings")

return M
