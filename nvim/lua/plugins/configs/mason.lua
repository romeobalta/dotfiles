local options = {
	ensure_installed = {
		"lua-language-server",
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"json-lsp",
		"tailwindcss-language-server",
		"prettierd",
		"prettier",
		"eslint_d",

		-- rust
		"rust-analyzer",
		"codelldb",
		"taplo",

		-- shell
		"shfmt",
		"shellcheck",
		"bash-language-server",
	}, -- not an option from mason.nvim

	PATH = "skip",

	ui = {
		icons = {
			package_pending = " ",
			package_installed = "󰄳 ",
			package_uninstalled = " 󰚌",
		},

		keymaps = {
			toggle_server_expand = "<CR>",
			install_server = "i",
			update_server = "u",
			check_server_version = "c",
			update_all_servers = "U",
			check_outdated_servers = "C",
			uninstall_server = "X",
			cancel_installation = "<C-c>",
		},
	},

	max_concurrent_installers = 10,
}

return options
