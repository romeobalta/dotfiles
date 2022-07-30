local M = {}

M.custom = {
	n = {
		["<leader>bd"] = { "<cmd> :bp | bd# <CR>", "close current buffer", opts = {} },
		["P"] = { '"0p', "paste yanked not deleted", opts = {} },
		["<A-k>"] = { "<cmd> :MoveLine(-1)<CR>", "move line down", opts = { noremap = true, silent = true } },
		["<A-j>"] = { "<cmd> :MoveLine(1)<CR>", "move line up", opts = { noremap = true, silent = true } },
		["<A-Up>"] = { "<cmd> :MoveLine(-1)<CR>", "move line up", opts = { noremap = true, silent = true } },
		["<A-Down>"] = { "<cmd> :MoveLine(1)<CR>", "move line down", opts = { noremap = true, silent = true } },
		["<leader>ss"] = {
			"<cmd> :SessionManager save_current_session<CR>",
			"save current session",
			opts = { noremap = true },
		},
		["<leader>sl"] = { "<cmd> :SessionManager load_session<CR>", "load session", opts = { noremap = true } },
		["<leader>sd"] = { "<cmd> :SessionManager delete_session<CR>", "delete session", opts = { noremap = true } },
		["<leader>sp"] = {
			"<cmd> :SessionManager load_last_session<CR>",
			"load last session",
			opts = { noremap = true },
		},

		["<leader>frr"] = { ":%s/", "enter search and replace", opts = { nowait = true } },
	},

	i = {
		["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },
	},

	v = {
		["<A-k>"] = { "<cmd> :MoveBlock(-1)<CR>", "move line down", opts = { noremap = true, silent = true } },
		["<A-j>"] = { "<cmd> :MoveBlock(1)<CR>", "move line up", opts = { noremap = true, silent = true } },
		["<A-Up>"] = { "<cmd> :MoveBlock(-1)<CR>", "move line up", opts = { noremap = true, silent = true } },
		["<A-Down>"] = { "<cmd> :MoveBlock(1)<CR>", "move line down", opts = { noremap = true, silent = true } },
	},
}

M.lspconfig = {
	n = {
		["gi"] = {
			function()
				vim.lsp.buf.implementation()
			end,
			"   lsp implementation",
		},

		["<leader>gs"] = {
			function()
				vim.lsp.buf.signature_help()
			end,
			"   lsp signature_help",
		},

		["<leader>gd"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			"   lsp definition type",
		},

		["<leader>gra"] = {
			function()
				require("nvchad_ui.renamer").open()
			end,
			"   lsp rename",
		},

		["<leader>gq"] = {
			function()
				vim.diagnostic.setloclist()
			end,
			"   diagnostic setloclist",
		},

		["<leader>frm"] = {
			"<cmd> :RustFmt<CR>",
			"   lsp formatting",
		},
	},
}

M.telescope = {
	n = {
		-- find
		["<leader>fs"] = { "<cmd> Telescope live_grep <CR>", "   live grep" },
		["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "   show keys" },

		-- git
		["<leader>fcm"] = { "<cmd> Telescope git_commits <CR>", "   git commits" },
		["<leader>fgt"] = { "<cmd> Telescope git_status <CR>", "  git status" },

		-- pick a hidden term
		["<leader>fpt"] = { "<cmd> Telescope terms <CR>", "   pick hidden term" },
	},
}

return M
