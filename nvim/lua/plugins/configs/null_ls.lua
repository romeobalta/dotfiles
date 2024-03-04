local null_ls = require("null-ls")

local config = {
	debug = true,
	sources = {
		-- webdev stuff
		null_ls.builtins.formatting.prettierd,

		-- Lua
		null_ls.builtins.formatting.stylua,

		-- Shell
		null_ls.builtins.formatting.shfmt,
	},
}

return config
