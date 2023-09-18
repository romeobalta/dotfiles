local config = {
	suggestion = {
    enabled = true,
		auto_trigger = false,
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

}

return config
