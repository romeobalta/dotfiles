local options = {
	indentLine_enabled = 1,
	filetype_exclude = {
		"",
		"TelescopePrompt",
		"TelescopeResults",
		"alpha",
		"help",
		"lazy",
		"lsp-installer",
		"lspinfo",
		"mason",
		"norg",
		"nvchad_cheatsheet",
		"nvcheatsheet",
		"nvdash",
		"packer",
		"terminal",
	},
	buftype_exclude = { "terminal" },
	show_trailing_blankline_indent = false,
	show_first_indent_level = false,
	show_current_context = true,
	show_current_context_start = true,
}

return options
