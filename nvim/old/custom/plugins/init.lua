local override = require("custom.override")

return {

	-- autoclose tags in html, jsx etc
	["windwp/nvim-ts-autotag"] = {
		ft = { "html", "javascriptreact" },
		after = "nvim-treesitter",
		config = function()
			require("custom.plugins.smolconfigs").autotag()
		end,
	},

	-- format & linting
	["jose-elias-alvarez/null-ls.nvim"] = {
		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.null-ls")
		end,
	},

	-- get highlight group under cursor
	["nvim-treesitter/playground"] = {
		cmd = "TSCaptureUnderCursor",
		config = function()
			require("nvim-treesitter.configs").setup()
		end,
	},

	-- dim inactive windows
	["andreadev-it/shade.nvim"] = {
		module = "shade",
		config = function()
			require("custom.plugins.smolconfigs").shade()
		end,
	},

	["Pocco81/AutoSave.nvim"] = {
		module = "autosave",
		config = function()
			require("custom.plugins.smolconfigs").autosave()
		end,
	},

	["goolord/alpha-nvim"] = {
		disable = false,
		cmd = "Alpha",
	},

	["neovim/nvim-lspconfig"] = {
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.plugins.lspconfig")
		end,
	},

	["fedepujol/move.nvim"] = {
		disable = true,
	},

	["folke/which-key.nvim"] = {
		disable = false,
	},

	-- rust
	["simrat39/rust-tools.nvim"] = {
		requires = { "rust-lang/rust.vim", "neovim/nvim-lspconfig" },
		ft = "rust",

		config = function()
			local options = require("custom.plugins.smolconfigs").rust_tools()

			require("rust-tools").setup(options)
		end,
	},

	-- dap
	["nvim-lua/plenary.nvim"] = {},
	["mfussenegger/nvim-dap"] = {},

	-- session
	["Shatur/neovim-session-manager"] = {
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			local Path = require("plenary.path")

			require("session_manager").setup({
				sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"), -- The directory where the session files will be saved.
				path_replacer = "__", -- The character to which the path separator will be replaced for session files.
				colon_replacer = "++", -- The character to which the colon symbol will be replaced for session files.
				autoload_mode = require("session_manager.config").AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
				autosave_last_session = true, -- Automatically save last session on exit and on session switch.
				autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
				autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
					"gitcommit",
				},
				autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
				max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
			})
		end,
	},

	["nvim-telescope/telescope-live-grep-args.nvim"] = {},

	["nvim-telescope/telescope-ui-select.nvim"] = {},

	["nvim-telescope/telescope-fzf-native.nvim"] = {
		run = "make",
	},

	["nvim-telescope/telescope.nvim"] = {
		cmd = false,
		override_options = override.telescope,
	},

	["nvim-tree/nvim-tree.lua"] = { override_options = override.nvimtree },

	["lukas-reineke/indent-blankline.nvim"] = { override_options = override.blankline },

	["williamboman/mason.nvim"] = { override_options = override.mason },

	["williamboman/mason-lspconfig.nvim"] = {},

	["hrsh7th/nvim-cmp"] = { override_options = override.cmp },

	["NvChad/ui"] = { override_options = override.ui },

	["zbirenbaum/copilot.lua"] = {
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept = false,
						accept_word = false,
						accept_line = false,
						next = false,
						prev = false,
						dismiss = false,
					},
				},
			})
		end,
	},

	["danielvolchek/tailiscope.nvim"] = {},

	["nvim-tree/nvim-web-devicons"] = {},

	["folke/zen-mode.nvim"] = {
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 1,
					width = 0.5,
					height = 1,
				},
			})
		end,
	},

	-- LSP completion source:
	["hrsh7th/cmp-nvim-lsp"] = {},

	-- [ful completion sources] = {},
	["hrsh7th/cmp-nvim-lua"] = {},
	["hrsh7th/cmp-nvim-lsp-signature-help"] = {},
	["hrsh7th/cmp-vsnip"] = {},
	["hrsh7th/cmp-path"] = {},
	["hrsh7th/cmp-buffer"] = {},
	["hrsh7th/vim-vsnip"] = {},

	-- dap
	["rcarriga/nvim-dap-ui"] = {
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("dapui").setup({
				layouts = {
					{
						elements = {
							{
								id = "watches",
								size = 0.45,
							},
							{
								id = "breakpoints",
								size = 0.25,
							},
							{
								id = "scopes",
								size = 0.15,
							},
							{
								id = "stacks",
								size = 0.15,
							},
						},
						position = "left",
						size = 60,
					},
					{
						elements = {
							{
								id = "console",
								size = 0.5,
							},
							{
								id = "repl",
								size = 0.5,
							},
						},
						position = "bottom",
						size = 10,
					},
				},
			})
		end,
	},
	["theHamsta/nvim-dap-virtual-text"] = {
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
}