local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"html",
		"css",
		"javascript",
		"json",
		"jsonc",
		"json5",
		"toml",
		"yaml",
		"markdown",
		"c",
		"bash",
		"lua",
		"astro",
		"comment",
		"dockerfile",
		"dot",
		"go",
		"gomod",
		"http",
		"javascript",
		"lua",
		"prisma",
		"python",
		"tsx",
		"regex",
		"sql",
		"typescript",
		"rust",
	},
}

M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

M.blankline = {
	filetype_exclude = {
		"help",
		"terminal",
		"alpha",
		"packer",
		"lspinfo",
		"TelescopePrompt",
		"TelescopeResults",
		"nvchad_cheatsheet",
		"lsp-installer",
		"norg",
		"",
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",
		"emmet-ls",
		"json-lsp",
		"tailwindcss-language-server",
		"prettierd",
		"prettier",
		"eslint_d",

		-- rust
		"rust-analyzer",
		"taplo",

		-- shell
		"shfmt",
		"shellcheck",
	},
}

-- arrow completion and snippet jumping using arrow keys
M.cmp = function()
	local cmp = require("cmp")

	return {
		mapping = {
			["<Down>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif require("luasnip").expand_or_jumpable() then
					vim.fn.feedkeys(
						vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
						""
					)
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),

			["<Up>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif require("luasnip").jumpable(-1) then
					vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),

      ["<C-g>"] = cmp.mapping.scroll_docs(-4),
		},
	}
end

return M
