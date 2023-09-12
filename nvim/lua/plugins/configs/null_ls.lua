local null_ls = require("null-ls")

local config = {
	debug = true,
	sources = {
		-- webdev stuff
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.code_actions.eslint_d,
		null_ls.builtins.diagnostics.eslint_d,

		-- Lua
		null_ls.builtins.formatting.stylua,

		-- Shell
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
	},
}

return config
