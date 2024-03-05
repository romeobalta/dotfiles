local config = {
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

	panel = {
		enabled = true,
		auto_refresh = false,
		keymap = {
			jump_prev = "<C-k>",
			jump_next = "<C-j>",
			accept = "<CR>",
			refresh = "<C-r>",
		},
	},

	filetypes = {
		lua = true,

		typescript = true,
		typescriptreact = true,
		javascript = true,
		javascriptreact = true,
		json = true,
		yaml = true,

		go = true,
		rust = true,

		python = true,
	},
}

return config
