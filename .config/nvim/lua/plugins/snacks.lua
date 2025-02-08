return {
	{ "nvim-lua/plenary.nvim", lazy = true },

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			debug = { enabled = true },
			dashboard = {
				preset = {
					pick = function(cmd, opts)
						return fzf_open(cmd, opts)()
					end,
					header = [[ ]],
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
			lazygit = { enabled = true, },
			notifier = {
				enabled = true,
				top_down = false,
				timeout = 5000,
				width = {
					min = 10,
					max = 0.4,
				},
				---@type snacks.notifier.render
				style = function(buf, notif, ctx)
					ctx.opts.border = "none"
					local whl = ctx.opts.wo.winhighlight
					local hl_msg = ctx.hl.icon == "SnacksNotifierIconSuccess" and "SnacksNotifierSuccess" or ctx.hl.msg
					ctx.opts.wo.winhighlight = whl:gsub(ctx.hl.msg, hl_msg .. "Minimal")
					local lines = vim.split(notif.msg, "\n")
					lines[1] = lines[1] .. "   "
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
					vim.api.nvim_buf_set_extmark(buf, ctx.ns, 0, 0, {
						virt_text = { { notif.icon, ctx.hl.icon } },
						virt_text_pos = "right_align",
					})
				end,
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
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command

					if vim.fn.executable("lazygit") == 1 then
						vim.keymap.set("n", "<C-g>", function()
							Snacks.lazygit({ cwd = Util.root.git() })
						end, { desc = "Lazygit (Root Dir)" })
						vim.keymap.set("n", "<leader>gf", function()
							Snacks.picker.git_log_file()
						end, { desc = "Git Current File History" })
						vim.keymap.set("n", "<leader>gl", function()
							Snacks.picker.git_log({ cwd = Util.root.git() })
						end, { desc = "Git Log" })
						vim.keymap.set("n", "<leader>gL", function()
							Snacks.picker.git_log()
						end, { desc = "Git Log (cwd)" })
					end

					---@param msg string|string[]
					---@param opts? snacks.notify.Opts
					function Snacks.notify.success(msg, opts)
						return Snacks.notify.notify(
							msg,
							vim.tbl_extend("force", opts or {}, {
								hl = {
									title = "SnacksNotifierTitleSuccess",
									icon = "SnacksNotifierIconSuccess",
									border = "SnacksNotifierBorderSuccess",
									footer = "SnacksNotifierSuccess",
									message = "SnacksNotifierSuccess",
								},
								icon = "",
							})
						)
					end

					Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
					Snacks.toggle.zen():map("<leader>uz")
				end,
			})
		end,
	},
}
