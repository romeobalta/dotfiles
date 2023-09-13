local M = {}

local catppuccin = require("core.themes.catppuccin")
local tokyodark = require("core.themes.tokyodark")

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

		StFileName = {
			fg = "orange",
		},

		HarpoonInactive = {
			fg = "light_grey",
		},
		HarpoonActive = {
			bg = "lightbg",
			fg = "sun",
		},
		HarpoonNumberInactive = {
			fg = "nord_blue",
		},
		HarpoonNumberActive = {
			fg = "dark_purple",
			bg = "lightbg",
		},

		TabLineFill = {
			fg = "statusline_bg",
		},

		TelescopeMatching = {
			fg = "dark_purple",
		},

		Cursor = {
			fg = "darker_black",
			bg = "lightbg",
		},
		TermCursor = {
			fg = "darker_black",
			bg = "lightbg",
		},
	},
	hl_override = {
		St_EmptySpace = {
			fg = "lightbg",
		},

		St_EmptySpace2 = {
			fg = "black",
			bg = "black",
		},

		St_NormalModeSep = {
			bg = "lightbg",
		},

		NvimTreeGitDirty = {
			fg = "sun",
		},

		Cursor = {
			fg = "darker_black",
			bg = "lightbg",
		},
		TermCursor = {
			fg = "darker_black",
			bg = "lightbg",
		},

		TelescopeSelection = {
			fg = "darker_black",
			bg = "white",
		},
		TelescopeMatching = {
			fg = "dark_purple",
		},
		TelescopeNormal = {
			bg = "darker_black",
		},
		TelescopePromptNormal = {
			bg = "darker_black",
		},
		TelescopePromptPrefix = {
			bg = "darker_black",
		},
		TelescopePromptCounter = {
			fg = "light_grey",
		},
		TelescopeBorder = {
			fg = "light_grey",
			bg = "darker_black",
		},
		TelescopePromptBorder = {
			fg = "light_grey",
			bg = "darker_black",
		},
	},
	changed_themes = {
		gruvbox = {
			base_30 = {
				-- 	black = "#262626",
				statusline_bg = "#262626",
				-- 	line = "#7c6f64",
				-- grey = "#7c6f64",
				grey_fg = "#7c6f64",
				-- one_bg2 = "#41462d",
			},

			base_16 = {
				base02 = "#686563",
			},
		},

		catppuccin = catppuccin,
		tokyodark = tokyodark,
	},
	theme_toggle = { "onedark", "penumbra_light" },
	theme = "tokyodark", -- default theme
	transparency = true,
	lsp_semantic_tokens = true, -- needs nvim v0.9, just adds highlight groups for lsp semantic tokens

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

	telescope = { style = "bordered" }, -- borderless / bordered

	------------------------------- nvchad_ui modules -----------------------------
	statusline = {
		theme = "vscode_colored",
		overriden_modules = function(modules)
			local git = function()
				if not vim.b.gitsigns_head or vim.b.gitsigns_git_status or vim.o.columns < 120 then
					return ""
				end

				local git_status = vim.b.gitsigns_status_dict

				local added = (git_status.added and git_status.added ~= 0)
						and ("%#St_lspInfo#  " .. git_status.added .. " ")
					or ""
				local changed = (git_status.changed and git_status.changed ~= 0)
						and ("%#St_lspWarning# 󰝥 " .. git_status.changed .. " ")
					or ""
				local removed = (git_status.removed and git_status.removed ~= 0)
						and ("%#St_lspError#  " .. git_status.removed .. " ")
					or ""

				return (added .. changed .. removed) ~= "" and (added .. changed .. removed .. " | ") or ""
			end

			local fileinfo = function()
				local icon = " 󰈚 "
				local fn = vim.fn
				local filename = (fn.expand("%") == "" and "Empty ") or fn.expand("%:p")

				-- get the path relative to the current working directory
				filename = fn.fnamemodify(filename, ":~:.") -- :~:. strips the cwd from the path

				if filename ~= "Empty " then
					local devicons_present, devicons = pcall(require, "nvim-web-devicons")

					if devicons_present then
						local ft_icon = devicons.get_icon(filename)
						icon = (ft_icon ~= nil and " " .. ft_icon) or ""
					end

					filename = " " .. filename .. " "
				end

				return "%#StFileName# " .. icon .. filename .. "%#StNormal#"
			end

			modules[8] = git()
			modules[2] = fileinfo()
		end,
	},

	-- lazyload it when there are 1+ buffers
	tabufline = {
		show_numbers = true,
		enabled = false,
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

M.lazy_nvim = require("plugins.configs.lazy_nvim") -- config for lazy.nvim startup options

M.mappings = require("core.mappings")

return M
