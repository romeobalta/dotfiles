local M = {}

M.disabled = {
	n = {
		["<C-t>"] = "",
	},

  i = {
    ["<C-t>"] = "",
  },

	v = {
		["<C-t>"] = "",
	},
}

M.custom = {
	n = {
		["<leader>bd"] = { "<cmd> :bp | bd# <CR>", " close current buffer", opts = {} },
		["<leader>fr"] = { ":%s/", "  enter search and replace", opts = { nowait = true } },
		["<leader>w"] = { "<C-w>", "window operations", opts = { nowait = true } },

		["<leader>z"] = { "<cmd>:ZenMode<CR>", "toggle zen mode", opts = {} },

		-- append and prepend in block
		["<leader>a"] = {
			function()
				vim.go.operatorfunc = "v:lua.append"
				vim.api.nvim_feedkeys("g@", "n", false)
			end,
			"append in block",
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
		["<C-Enter>"] = { "maO<ESC>'a", "ﲗ add line above", opts = { noremap = true } },
		["<C-S-Enter>"] = { "mao<ESC>'a", "ﲔ add line below", opts = { noremap = true } },

		-- jump back
		["<C-b>"] = { "<C-O>", "碑 jump back", opts = { noremap = true } },

		-- move cursor
		["gs"] = { "^", " move cursor at start of the line", opts = { noremap = true } },
		["gl"] = { "$", " move cursor at end of the line", opts = { noremap = true } },
    
    -- dap
    ["<leader>dt"] = {
      "<cmd>:lua require('dapui').toggle()<CR>",
      "ﲔ dap toggle",
      opts = { noremap = true },
    },
    ["<leader>db"] = {
      "<cmd> :DapToggleBreakpoint<CR>",
      "ﲔ dap toggle breakpoint",
      opts = { noremap = true },
    },
    ["<leader>dc"] = {
      "<cmd> :DapContinue<CR>",
      "ﲔ dap continue",
      opts = { noremap = true },
    },
    ["<leader>ds"] = {
      "<cmd> :DapStepOver<CR>",
      "ﲔ dap step over",
      opts = { noremap = true },
    },
    ["<leader>di"] = {
      "<cmd> :DapStepInto<CR>",
      "ﲔ dap step into",
      opts = { noremap = true },
    },
    ["<leader>do"] = {
      "<cmd> :DapStepOut<CR>",
      "ﲔ dap step out",
      opts = { noremap = true },
    },
    ["<leader>dx"] = {
      "<cmd> :DapTerminate<CR>",
      "ﲔ dap terminate",
      opts = { noremap = true },
    },
    ["<leader>dr"] = {
      "<cmd>:lua require('dapui').open({ reset = true })<CR>",
      "ﲔ dap reset ui",
      opts = { noremap = true },
    }
	},

	i = {
		["jk"] = { "<ESC>", "escape insert mode", opts = { nowait = true } },

		-- add empty lines
		["<C-Enter>"] = { "<C-o>ma<C-o>o<C-o>'a", "ﲔ add line below", opts = { noremap = true } },

		-- undo
		["<C-u>"] = { "<C-o>u", "碑 undo in insert mode", opts = { noremap = true } },

		-- exit insert and save
		["<C-s>"] = { "<ESC><cmd> :w<CR>", "exit insert mode and save", opts = { noremap = true } },

		-- copilot
		["<C-w>"] = {
			function()
				require("copilot.suggestion").accept_word()
        print("copilot")
			end,
			"ﲔ accept word suggestion",
			opts = { noremap = true },
		},
		["<C-l>"] = {
			function()
				require("copilot.suggestion").accept_line()
			end,
			"ﲔ accept line suggestion",
			opts = { noremap = true },
		},
		["<C-k>"] = {
			function()
				require("copilot.suggestion").next()
			end,
			"ﲔ next suggestion",
			opts = { noremap = true },
		},
		["<C-j>"] = {
			function()
				require("copilot.suggestion").prev()
			end,
			"ﲔ prev suggestion",
			opts = { noremap = true },
		},
		["<C-h>"] = {
			function()
				require("copilot.suggestion").dismiss()
			end,
			"ﲔ dismiss suggestion",
			opts = { noremap = true },

		},
		["<Tab>"] = {
			function()
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
				else
					vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
				end
			end,
			"ﲔ accept suggestion",
			opts = { noremap = true },
		},

	},

	v = {
		["y"] = { "ygv<ESC>", "yank then go at the end of the block", opts = { noremap = true } },
		["<leader>y"] = { '"*y', "yank into clipboard", opts = { noremap = true } },
	},
}

M.rust = {
	n = {
		["<leader>rn"] = { "<cmd> :RustRunnables <CR>", "ﰌ rust runnables", opts = {} },
		["<leader>rd"] = { "<cmd> :RustDebuggables <CR>", "ﰌ rust debuggables", opts = {} },
		["<leader>rr"] = { "<cmd> :RustRun <CR>", "ﰌ rust run", opts = {} },
		["<leader>re"] = { "<cmd> :RustExpandMacro <CR>", "ﲖ rust expand", opts = {} },
	},
}

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
		["gs"] = {
			function()
				vim.lsp.buf.signature_help()
			end,
			" lsp signature_help",
		},

		["gt"] = {
			function()
				vim.lsp.buf.type_definition()
			end,
			" lsp definition type",
		},

		["gc"] = {
			function()
				require("nvchad_ui.renamer").open()
			end,
			" lsp rename",
		},

		["gq"] = {
			"<cmd> :Telescope diagnostics <CR>",
			" diagnostic",
		},

		["<leader>q"] = {
			"<cmd> :Telescope diagnostics <CR>",
			" diagnostic",
		},

		-- add support for Rust formatting with RustFmt
		["<leader>fm"] = {
			function()
				if vim.fn.exists(":RustFmt") > 0 then
					vim.fn["rustfmt#Format"]()
				else
					vim.lsp.buf.format()
				end
			end,
			" lsp formatting",
			opts = { noremap = false },
		},

		["gr"] = {
			"<cmd> :Telescope lsp_references <CR>",
			" lsp references",
			opts = { noremap = false },
		},

		["gd"] = {
			"<cmd> :Telescope lsp_definitions <CR>",
			" lsp definitions",
			opts = { noremap = false },
		},
	},
}

M.telescope = {
	n = {
		-- find
		["<leader>fs"] = {
			"<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
			" live grep",
		},
		["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", "  show keys" },
		["<leader>fds"] = { "<cmd> Telescope lsp_document_symbols <CR>", "@  show document symbols" },
		["<leader>fch"] = { "<cmd> Telescope command_history <CR>", "  show command history" },
		["<leader>fsh"] = { "<cmd> Telescope search_history <CR>", "  show search history" },
		["<leader>flm"] = { "<cmd> Telescope marks <CR>", "  show marks" },
		["<leader>fll"] = { "<cmd> Telescope loclist<CR>", "  show loclist" },
		["<leader>flj"] = { "<cmd> Telescope jumplist<cr>", "  show jumplist" },

		-- git
		["<leader>fgc"] = { "<cmd> Telescope git_commits <CR>", "  git commits" },
		["<leader>fgs"] = { "<cmd> Telescope git_status <CR>", " git status" },

		-- pick a hidden term
		["<leader>fpt"] = { "<cmd> Telescope terms <CR>", "  pick hidden term" },
	},
}

return M
