Util.on_very_lazy(function()
	vim.filetype.add({
		extension = { mdx = "markdown.mdx" },
	})
end)

return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters = {
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
			formatters_by_ft = {
				["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
			},
		},
	},

	{
		"mason-org/mason.nvim",
		opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc" } },
	},

	{
		"mfussenegger/nvim-lint",
		opts = {
			linters_by_ft = {
				markdown = { "markdownlint-cli2" },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				marksman = {},
			},
		},
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>cp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
				left_pad = 1,
				conceal_delimiters = false,
				border = "thin",
				inline_pad = 1,
			},
			heading = {
				sign = false,
				icons = {},
				backgrounds = {
					"RenderMarkdownH1Bg",
					"RenderMarkdownH1Bg",
					"RenderMarkdownH1Bg",
					"RenderMarkdownH1Bg",
					"RenderMarkdownH1Bg",
					"RenderMarkdownH1Bg",
				},
				foregrounds = {
					"RenderMarkdownH1",
					"RenderMarkdownH1",
					"RenderMarkdownH1",
					"RenderMarkdownH1",
					"RenderMarkdownH1",
					"RenderMarkdownH1",
				},
			},
			checkbox = {
				unchecked = {
					icon = "󰄱 ",
				},
				checked = {
					icon = "󰱒 ",
				},
			},
		},
		ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
		config = function(_, opts)
			require("render-markdown").setup(opts)
			Snacks.toggle({
				name = "Render Markdown",
				get = function()
					return require("render-markdown.state").enabled
				end,
				set = function(enabled)
					local m = require("render-markdown")
					if enabled then
						m.enable()
					else
						m.disable()
					end
				end,
			}):map("<leader>um")
		end,
	},
}
