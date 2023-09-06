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
		indent_markers = {
			enable = false,
		},

		icons = {
			show = {
				git = true,
			},

			glyphs = {
				git = {
					-- unstaged = "✗",
					-- staged = "✓",
					-- unmerged = "",
					-- renamed = "➜",
					-- untracked = "★",
					-- deleted = "",
					-- ignored = "◌",
					unstaged = "",
				},
			},
		},
	},

	actions = {
		open_file = {
			quit_on_open = true,
		},
	},

  sort_by = "name",
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
		"codelldb",
		"taplo",

		-- shell
		"shfmt",
		"shellcheck",
		"bash-language-server",
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

			-- disable so we can use copilot
			["<Tab>"] = cmp.config.disable,
			["<S-Tab>"] = cmp.config.disable,
		},

		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},

		sources = {
			{ name = "path" }, -- file paths
			{ name = "nvim_lsp", keyword_length = 3 }, -- from language server
			{ name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
			{ name = "nvim_lua", keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
			{ name = "buffer", keyword_length = 2 }, -- source current buffer
			{ name = "vsnip", keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
			{ name = "calc" }, -- source for math calculation
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		formatting = {
			fields = { "menu", "abbr", "kind" },
			format = function(entry, item)
				local menu_icon = {
					nvim_lsp = "λ",
					vsnip = "⋗",
					buffer = "Ω",
					path = "🖫",
				}
				item.menu = menu_icon[entry.source.name]
				return item
			end,
		},
	}
end

M.ui = {
	statusline = {
		separator_style = "arrow",
		overriden_modules = function()
			return {
				git = function()
					if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
						return ""
					end

					local git_status = vim.b.gitsigns_status_dict

					local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
					local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed)
						or ""
					local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed)
						or ""
					local branch_name = "   " .. git_status.head .. " "

					return "%#St_gitIcons#"
						.. branch_name
						.. "%#St_gitIcons_added#"
						.. added
						.. "%#St_gitIcons_changed#"
						.. changed
						.. "%#St_gitIcons_removed#"
						.. removed
				end,
			}
		end,
	},
}

M.telescope = function()
	local themes = require("telescope.themes")

	return {
		defaults = {
			prompt_prefix = "     ",
			layout_config = {
				cursor = {
					width = 1,
				},
			},
		},
		pickers = {
			diagnostics = {
				theme = "ivy",
				sort_by = "severity",
			},

			buffers = {
				mappings = {
					i = {
						["<c-d>"] = "delete_buffer",
					},
					n = {
						["<c-d>"] = "delete_buffer",
					},
				},
			},
		},
		extensions = {
			["ui-select"] = {
				themes.get_cursor({}),
				-- themes.get_dropdown({})
			},
			fzf = {},
			live_grep_args = {},
		},
		extensions_list = { "themes", "terms", "ui-select", "fzf", "live_grep_args" },
	}
end

return M
