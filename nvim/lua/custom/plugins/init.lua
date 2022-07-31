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

	-- rust
	["simrat39/rust-tools.nvim"] = {
		requires = { "rust-lang/rust.vim" },
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
				autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
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
}
