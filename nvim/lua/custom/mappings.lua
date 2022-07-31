local M = {}

M.custom = {
	n = {
		["<leader>bd"] = { "<cmd> :bp | bd# <CR>", " close current buffer", opts = {} },
		["<leader>fr"] = { ":%s/", "  enter search and replace", opts = { nowait = true } },

		-- append and prepend in block
		["<leader>a"] = {
			function()
				vim.go.operatorfunc = "v:lua.append"
				vim.api.nvim_feedkeys("g@", "n", false)
			end,
			"ﲒ append in block",
			opts = { silent = true },
		},
		["<leader>i"] = {
			function()
				vim.go.operatorfunc = "v:lua.prepend"
				vim.api.nvim_feedkeys("g@", "n", false)
			end,
			"ﲑ prepend in block",
			opts = { silent = true },
		},

		-- add empty lines
		["<C-k>"] = { "maO<ESC>'a", "ﲗ add line above", opts = { noremap = true } },
		["<C-j>"] = { "mao<ESC>'a", "ﲔ add line below", opts = { noremap = true } },
		["<C-Enter>"] = { "maO<ESC>'a", "ﲗ add line above", opts = { noremap = true } },
		["<C-S-Enter>"] = { "mao<ESC>'a", "ﲔ add line below", opts = { noremap = true } },
	},

	i = {
		["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },

		-- add empty lines
		["<C-j>"] = { "<C-o>ma<C-o>o<C-o>'a", "ﲔ add line below", opts = { noremap = true } },
		["<C-k>"] = { "<C-o>ma<C-o>O<C-o>'a", "ﲗ add line above", opts = { noremap = true } },
		["<C-Enter>"] = { "<C-o>ma<C-o>o<C-o>'a", "ﲔ add line below", opts = { noremap = true } },
		["<C-S-Enter>"] = { "<C-o>ma<C-o>O<C-o>'a", "ﲗ add line above", opts = { noremap = true } },

		-- undo
		["<C-u>"] = { "<C-o>u", "碑 undo in insert mode", opts = { noremap = true } },
	},

	v = {
		["y"] = { "ygv<ESC>", "yank then go at the end of the block", opts = { noremap = true } },
	},
}

M.rust = {
	n = {
		["<leader>rn"] = { "<cmd> :RustRunnables <CR>", "ﰌ rust runnables", opts = {} },
		["<leader>rr"] = { "<cmd> :RustRun <CR>", "ﰌ rust run", opts = {} },
		["<leader>re"] = { "<cmd> :RustExpandMacro <CR>", "ﲖ rust expand", opts = {} },
	},
}

-- M.move_lines = {
-- 	n = {
-- 		["<A-k>"] = { "<cmd> :MoveLine(-1)<CR>", "move line down", opts = { noremap = true, silent = true } },
-- 		["<A-j>"] = { "<cmd> :MoveLine(1)<CR>", "move line up", opts = { noremap = true, silent = true } },
-- 		["<A-Up>"] = { "<cmd> :MoveLine(-1)<CR>", "move line up", opts = { noremap = true, silent = true } },
-- 		["<A-Down>"] = { "<cmd> :MoveLine(1)<CR>", "move line down", opts = { noremap = true, silent = true } },
-- 	},
--
-- 	v = {
-- 		["<A-k>"] = { "<cmd> :'<, '>MoveBlock(-1)<CR>", "move line down", opts = { noremap = true, silent = true } },
-- 		["<A-j>"] = { "<cmd> :'<, '>MoveBlock(1)<CR>", "move line up", opts = { noremap = true, silent = true } },
-- 	},
-- }

M.session = {
	n = {
		["<leader>ss"] = {
			"<cmd> :SessionManager save_current_session<CR>",
			" save current session",
			opts = { noremap = true },
		},
		["<leader>sl"] = { "<cmd> :SessionManager load_session<CR>", "load session", opts = { noremap = true } },
		["<leader>sd"] = { "<cmd> :SessionManager delete_session<CR>", "delete session", opts = { noremap = true } },
		["<leader>sp"] = {
			"<cmd> :SessionManager load_last_session<CR>",
			" load last session",
			opts = { noremap = true },
		},
	},
}

M.lspconfig = {
	n = {
		["<leader>gs"] = {
			function()
				vim.lsp.buf.signature_help()
			end,
			" lsp signature_help",
		},

		["<leader>gd"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			" lsp definition type",
		},

		["<leader>gr"] = {
			function()
				require("nvchad_ui.renamer").open()
			end,
			" lsp rename",
		},

		["<leader>gq"] = {
			function()
				vim.diagnostic.setloclist()
			end,
			" diagnostic setloclist",
		},

		-- add support for Rust formatting with RustFmt
		["<leader>fm"] = {
			function()
				if vim.fn.exists(":RustFmt") > 0 then
					vim.fn["rustfmt#Format"]()
				else
					vim.lsp.buf.formatting()
				end
			end,
			" lsp formatting",
			opts = { noremap = false },
		},
	},
}

M.telescope = {
	n = {
		-- find
		["<leader>fs"] = { "<cmd> Telescope live_grep <CR>", " live grep" },
		["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "  show keys" },

		-- git
		["<leader>fgc"] = { "<cmd> Telescope git_commits <CR>", "  git commits" },
		["<leader>fgs"] = { "<cmd> Telescope git_status <CR>", " git status" },

		-- pick a hidden term
		["<leader>fpt"] = { "<cmd> Telescope terms <CR>", "  pick hidden term" },
	},
}

return M
