local extensions = require("plugins.snacks.extensions")

return {
	-- plenary
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- snacks
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
            image = { enabled = true },
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			debug = { enabled = true },
			dashboard = {
				preset = {
					pick = function(cmd, opts)
						return fzf_open(cmd, opts)()
					end,
					header = [[ Hello! ]],
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
			git = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			lazygit = { enabled = true },
			notifier = {
				enabled = true,
				top_down = false,
				timeout = 5000,
				width = {
					min = 20,
					max = 0.4,
				},
				style = extensions.minimal_improved,
				margin = {
					bottom = 1,
				},
			},
			notify = { enabled = true },
			quickfile = { enabled = true },
			rename = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>bo",
				function()
					Snacks.bufdelete.other()
				end,
				desc = "Delete Other Buffer",
			},
			{
				"<leader>n",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification History",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss All Notifications",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					extensions.setup()

					Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
					Snacks.toggle.zen():map("<leader>uz")
				end,
			})
		end,
	},
}
