local cmp = require("plugins.editor.cmp")

-- taken from MiniExtra.gen_ai_spec.buffer
local function ai_buffer(ai_type)
	local start_line, end_line = 1, vim.fn.line("$")
	if ai_type == "i" then
		-- Skip first and last blank lines for `i` textobject
		local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
		-- Do nothing for buffer with all blanks
		if first_nonblank == 0 or last_nonblank == 0 then
			return { from = { line = start_line, col = 1 } }
		end
		start_line, end_line = first_nonblank, last_nonblank
	end

	local to_col = math.max(vim.fn.getline(end_line):len(), 1)
	return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

-- register all text objects with which-key
---@param opts table
local function ai_whichkey(opts)
	local objects = {
		{ " ", desc = "whitespace" },
		{ '"', desc = '" string' },
		{ "'", desc = "' string" },
		{ "(", desc = "() block" },
		{ ")", desc = "() block with ws" },
		{ "<", desc = "<> block" },
		{ ">", desc = "<> block with ws" },
		{ "?", desc = "user prompt" },
		{ "U", desc = "use/call without dot" },
		{ "[", desc = "[] block" },
		{ "]", desc = "[] block with ws" },
		{ "_", desc = "underscore" },
		{ "`", desc = "` string" },
		{ "a", desc = "argument" },
		{ "b", desc = ")]} block" },
		{ "c", desc = "class" },
		{ "d", desc = "digit(s)" },
		{ "e", desc = "CamelCase / snake_case" },
		{ "f", desc = "function" },
		{ "g", desc = "entire file" },
		{ "i", desc = "indent" },
		{ "o", desc = "block, conditional, loop" },
		{ "q", desc = "quote `\"'" },
		{ "t", desc = "tag" },
		{ "u", desc = "use/call" },
		{ "{", desc = "{} block" },
		{ "}", desc = "{} with ws" },
	}

	---@type wk.Spec[]
	local ret = { mode = { "o", "x" } }
	---@type table<string, string>
	local mappings = vim.tbl_extend("force", {}, {
		around = "a",
		inside = "i",
		around_next = "an",
		inside_next = "in",
		around_last = "al",
		inside_last = "il",
	}, opts.mappings or {})
	mappings.goto_left = nil
	mappings.goto_right = nil

	for name, prefix in pairs(mappings) do
		name = name:gsub("^around_", ""):gsub("^inside_", "")
		ret[#ret + 1] = { prefix, group = name }
		for _, obj in ipairs(objects) do
			local desc = obj.desc
			if prefix:sub(1, 1) == "i" then
				desc = desc:gsub(" with ws", "")
			end
			ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
		end
	end
	require("which-key").add(ret, { notify = false })
end

---@param opts {skip_next: string, skip_ts: string[], skip_unbalanced: boolean, markdown: boolean}
local function mini_pairs(opts)
	Snacks.toggle({
		name = "Mini Pairs",
		get = function()
			return not vim.g.minipairs_disable
		end,
		set = function(state)
			vim.g.minipairs_disable = not state
		end,
	}):map("<leader>up")

	local _mini_pairs = require("mini.pairs")
	_mini_pairs.setup(opts)
	local open = _mini_pairs.open
	---@diagnostic disable-next-line: duplicate-set-field
	_mini_pairs.open = function(pair, neigh_pattern)
		if vim.fn.getcmdline() ~= "" then
			return open(pair, neigh_pattern)
		end
		local o, c = pair:sub(1, 1), pair:sub(2, 2)
		local line = vim.api.nvim_get_current_line()
		local cursor = vim.api.nvim_win_get_cursor(0)
		local next = line:sub(cursor[2] + 1, cursor[2] + 1)
		local before = line:sub(1, cursor[2])
		if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
			return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
		end
		if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
			return o
		end
		if opts.skip_ts and #opts.skip_ts > 0 then
			local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
			for _, capture in ipairs(ok and captures or {}) do
				if vim.tbl_contains(opts.skip_ts, capture.capture) then
					return o
				end
			end
		end
		if opts.skip_unbalanced and next == c and c ~= o then
			local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
			local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
			if count_close > count_open then
				return o
			end
		end
		return open(pair, neigh_pattern)
	end
end

return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts_extend = { "spec" },
		opts = {
			preset = "helix",
			defaults = {},
			spec = {
				{
					mode = { "n", "v" },
					{ "<leader>c", group = "code" },
					{ "<leader>d", group = "debug" },
					{ "<leader>dp", group = "profiler" },
					{ "<leader>f", group = "file/find" },
					{ "<leader>g", group = "git" },
					{ "<leader>gh", group = "hunks" },
					{ "<leader>q", group = "quit/session" },
					{ "<leader>s", group = "search" },
					{ "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
					{ "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "gs", group = "surround" },
					{ "z", group = "fold" },
					{
						"<leader>b",
						group = "buffer",
						expand = function()
							return require("which-key.extras").expand.buf()
						end,
					},
					{
						"<leader>w",
						group = "windows",
						proxy = "<c-w>",
						expand = function()
							return require("which-key.extras").expand.win()
						end,
					},
					-- better descriptions
					{ "gx", desc = "Open with system app" },
				},
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "LazyFile",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
			},
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

                -- stylua: ignore start
                map("n", "]g", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, "Next Hunk")
                map("n", "[g", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, "Prev Hunk")
                map("n", "]G", function() gs.nav_hunk("last") end, "Last Hunk")
                map("n", "[G", function() gs.nav_hunk("first") end, "First Hunk")
                map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
                map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
                map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
                map("n", "<leader>ghd", gs.diffthis, "Diff This")
                map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
		},
	},
	{
		"gitsigns.nvim",
		opts = function()
			Snacks.toggle({
				name = "Git Signs",
				get = function()
					return require("gitsigns.config").config.signcolumn
				end,
				set = function(state)
					require("gitsigns").toggle_signs(state)
				end,
			}):map("<leader>uG")
		end,
	},

	-- better diagnostics list and others
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>cS",
				"<cmd>Trouble lsp toggle<cr>",
				desc = "LSP references/definitions/... (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
	},

	-- Finds and lists all of the TODO, HACK, BUG, etc comment
	-- in your project and loads them into a browsable list.
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "LazyFile",
		opts = {
			keywords = {
				FIX = {
					icon = "E ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = "W ", color = "warning" },
				HACK = { icon = "W ", color = "warning" },
				WARN = { icon = "W ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = "H ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = "H ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "T ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
        -- stylua: ignore
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end,              desc = "Next Todo Comment" },
            { "[t",         function() require("todo-comments").jump_prev() end,              desc = "Previous Todo Comment" },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>",                                   desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>",                                         desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",                 desc = "Todo/Fix/Fixme" },
        },
	},

	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
        -- stylua: ignore
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>qS", function() require("persistence").select() end,              desc = "Select Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
        },
	},

	{
		"saghen/blink.cmp",
		version = "*",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
			-- add blink.compat to dependencies
			{
				"saghen/blink.compat",
				opts = {},
				version = "*",
			},
		},
		event = "InsertEnter",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			snippets = {
				expand = function(snippet)
					return cmp.expand(snippet)
				end,
			},
			appearance = {
				nerd_font_variant = "mono",
				kind_icons = require("config").icons.kinds,
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = false,
				},
				trigger = {
					show_in_snippet = false,
				},
			},
			signature = { enabled = true },

			sources = {
				-- adding any nvim-cmp sources here will enable them
				-- with blink.compat
				compat = {},
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				cmdline = {},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- show at a higher priority than lsp
					},
				},
			},

			keymap = {
				preset = "super-tab",
				["<C-y>"] = { "select_and_accept" },
			},
		},
		---@param opts blink.cmp.Config | { sources: { compat: string[] } }
		config = function(_, opts)
			-- setup compat sources
			local enabled = opts.sources.default
			for _, source in ipairs(opts.sources.compat or {}) do
				opts.sources.providers[source] = vim.tbl_deep_extend(
					"force",
					{ name = source, module = "blink.compat.source" },
					opts.sources.providers[source] or {}
				)
				if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
					table.insert(enabled, source)
				end
			end

			-- add ai_accept to <Tab> key
			if opts.keymap.preset == "super-tab" then -- super-tab
				opts.keymap["<Tab>"] = {
					require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
					cmp.map({ "snippet_forward", "ai_accept" }),
					"fallback",
				}
			else -- other presets
				opts.keymap["<Tab>"] = {
					cmp.map({ "snippet_forward", "ai_accept" }),
					"fallback",
				}
			end

			-- Unset custom prop to pass blink.cmp validation
			opts.sources.compat = nil

			-- check if we need to override symbol kinds
			for _, provider in pairs(opts.sources.providers or {}) do
				---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
				if provider.kind then
					local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
					local kind_idx = #CompletionItemKind + 1

					CompletionItemKind[kind_idx] = provider.kind
					---@diagnostic disable-next-line: no-unknown
					CompletionItemKind[provider.kind] = kind_idx

					---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
					local transform_items = provider.transform_items
					---@param ctx blink.cmp.Context
					---@param items blink.cmp.CompletionItem[]
					provider.transform_items = function(ctx, items)
						items = transform_items and transform_items(ctx, items) or items
						for _, item in ipairs(items) do
							item.kind = kind_idx or item.kind
						end
						return items
					end

					-- Unset custom prop to pass blink.cmp validation
					provider.kind = nil
				end
			end

			require("blink.cmp").setup(opts)
		end,
	},

	-- auto pairs
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = true, terminal = false },
			-- skip autopair when next character is one of these
			skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
			-- skip autopair when the cursor is inside these treesitter nodes
			skip_ts = { "string" },
			-- skip autopair when next character is closing pair
			-- and there are more closing pairs than opening pairs
			skip_unbalanced = true,
			-- better deal with markdown code blocks
			markdown = true,
		},
		config = function(_, opts)
			mini_pairs(opts)
		end,
	},

	-- comments
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Better text-objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					g = ai_buffer, -- buffer
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			Util.on_load("which-key.nvim", function()
				vim.schedule(function()
					ai_whichkey(opts)
				end)
			end)
		end,
	},

	{
		"echasnovski/mini.surround",
		keys = function(_, keys)
			-- Populate the keys based on the user's options
			local opts = Util.opts("mini.surround")
			local mappings = {
				{ opts.mappings.add, desc = "Add Surrounding", mode = { "n", "v" } },
				{ opts.mappings.delete, desc = "Delete Surrounding" },
				{ opts.mappings.find, desc = "Find Right Surrounding" },
				{ opts.mappings.find_left, desc = "Find Left Surrounding" },
				{ opts.mappings.highlight, desc = "Highlight Surrounding" },
				{ opts.mappings.replace, desc = "Replace Surrounding" },
				{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			mappings = {
				add = "gsa", -- Add surrounding in Normal and Visual modes
				delete = "gsd", -- Delete surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				replace = "gsr", -- Replace surrounding
				update_n_lines = "gsn", -- Update `n_lines`
			},
		},
	},

	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename",
		opts = {},
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "Util", words = { "Util" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ path = "lazy.nvim", words = { "LazyVim" } },
			},
		},
	},
}
