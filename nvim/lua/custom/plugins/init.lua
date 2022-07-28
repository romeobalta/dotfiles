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

	["fedepujol/move.nvim"] = {},
}
