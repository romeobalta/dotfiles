local mini = require("plugins.editor.mini")
local extensions = require("plugins.editor.extensions")

return {
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({
				disable_when_zoomed = true, -- defaults to false
				keybindings = {
					left = "<C-h>",
					down = "<C-j>",
					up = "<C-k>",
					right = "<C-l>",
					last_active = "<C-\\>",
					next = "<C-Space>",
				},
			})
		end,
	},

	-- fzf-lua
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		opts = function(_, opts)
			local fzf = require("fzf-lua")
			local config = fzf.config
			local actions = fzf.actions

			-- Quickfix
			config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
			config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
			config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
			config.defaults.keymap.fzf["ctrl-x"] = "jump"
			config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
			config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
			config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
			config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

			-- Trouble
			if Util.has("trouble.nvim") then
				config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
			end

			-- Toggle root dir / cwd
			config.defaults.actions.files["ctrl-r"] = function(_, ctx)
				local o = vim.deepcopy(ctx.__call_opts)
				o.root = o.root == false
				o.cwd = nil
				o.buf = ctx.__CTX.bufnr
				fzf_open(ctx.__INFO.cmd, o)
			end
			config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
			config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

			local img_previewer ---@type string[]?
			for _, v in ipairs({
				{ cmd = "ueberzug", args = {} },
				{ cmd = "chafa", args = { "{file}", "--format=symbols" } },
				{ cmd = "viu", args = { "-b" } },
			}) do
				if vim.fn.executable(v.cmd) == 1 then
					img_previewer = vim.list_extend({ v.cmd }, v.args)
					break
				end
			end

			return {
				"default-title",
				fzf_colors = true,
				fzf_opts = {
					["--no-scrollbar"] = true,
					["--layout"] = "default",
				},
				defaults = {
					-- formatter = "path.filename_first",
					-- path_shorten = 1,
					formatter = "path.dirname_first",
				},
				previewers = {
					builtin = {
						extensions = {
							["png"] = img_previewer,
							["jpg"] = img_previewer,
							["jpeg"] = img_previewer,
							["gif"] = img_previewer,
							["webp"] = img_previewer,
						},
						ueberzug_scaler = "fit_contain",
					},
				},
				-- Custom LazyVim option to configure vim.ui.select
				ui_select = function(fzf_opts, items)
					return vim.tbl_deep_extend("force", fzf_opts, {
						prompt = " ",
						winopts = {
							title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
							title_pos = "center",
						},
					}, fzf_opts.kind == "codeaction" and {
						winopts = {
							layout = "vertical",
							-- height is number of items minus 15 lines for the preview, with a max of 80% screen height
							height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
							width = 0.8,
							preview = not vim.tbl_isempty(Util.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
								layout = "flex",
								vertical = "down:15,border-top",
								hidden = "hidden",
							} or {
								layout = "flex",
								vertical = "down:15,border-top",
							},
						},
					} or {
						winopts = {
							width = 0.5,
							-- height is number of items, with a max of 80% screen height
							height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
						},
					})
				end,
				winopts = {
					width = 0.8,
					height = 0.8,
					row = 0.5,
					col = 0.5,
					preview = {
						scrollchars = { "┃", "" },
					},
				},
				files = {
					cwd_prompt = false,
					actions = {
						["alt-i"] = { actions.toggle_ignore },
						["alt-h"] = { actions.toggle_hidden },
					},
				},
				grep = {
					hidden = true,
					actions = {
						["alt-i"] = { actions.toggle_ignore },
						["alt-h"] = { actions.toggle_hidden },
					},
				},
				lsp = {
					symbols = {
						symbol_hl = function(s)
							return "TroubleIcon" .. s
						end,
						symbol_fmt = function(s)
							return s:lower() .. "\t"
						end,
						child_prefix = false,
					},
					code_actions = {
						previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
					},
				},
			}
		end,
		config = function(_, opts)
			if opts[1] == "default-title" then
				-- use the same prompt for all pickers for profile `default-title` and
				-- profiles that use `default-title` as base profile
				local function fix(t)
					t.prompt = t.prompt ~= nil and " " or nil
					for _, v in pairs(t) do
						if type(v) == "table" then
							fix(v)
						end
					end
					return t
				end
				opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
				opts[1] = nil
			end
			require("fzf-lua").setup(opts)
		end,
		init = function()
			Util.on_very_lazy(function()
				vim.ui.select = function(...)
					require("lazy").load({ plugins = { "fzf-lua" } })
					local opts = Util.opts("fzf-lua") or {}
					require("fzf-lua").register_ui_select(opts.ui_select or nil)
					return vim.ui.select(...)
				end
			end)
		end,
		keys = {
			{
				"<c-j>",
				"<c-j>",
				ft = "fzf",
				mode = "t",
				nowait = true,
			},
			{
				"<c-k>",
				"<c-k>",
				ft = "fzf",
				mode = "t",
				nowait = true,
			},
			{ "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			-- find
			{ "<leader>fl", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{ "<leader><space>", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{
				"<leader>fc",
				fzf_open("files", { cwd = vim.fn.stdpath("config") }),
				desc = "Find Config File",
			},
			{
				"<leader>ff",
				fzf_open("files"),
				desc = "Find Files (Root Dir)",
			},
			{
				"<leader>fF",
				fzf_open("files", { root = false }),
				desc = "Find Files (cwd)",
			},
			{
				"<leader>fg",
				"<cmd>FzfLua git_files<cr>",
				desc = "Find Files (git-files)",
			},
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
			{ "<leader>fR", fzf_open("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
			-- git
			{ "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
			-- search
			{ '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
			{
				"<leader>sd",
				"<cmd>FzfLua diagnostics_document<cr>",
				desc = "Document Diagnostics",
			},
			{
				"<leader>sD",
				"<cmd>FzfLua diagnostics_workspace<cr>",
				desc = "Workspace Diagnostics",
			},
			{ "<leader>fs", fzf_open("live_grep"), desc = "Grep (Root Dir)" },
			{ "<leader>fS", fzf_open("live_grep", { root = false }), desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
			{
				"<leader>sH",
				"<cmd>FzfLua highlights<cr>",
				desc = "Search Highlight Groups",
			},
			{ "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
			{ "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
			{ "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
			{ "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
			{ "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
			{ "<leader>sw", fzf_open("grep_cword"), desc = "Word (Root Dir)" },
			{ "<leader>sW", fzf_open("grep_cword", { root = false }), desc = "Word (cwd)" },
			{
				"<leader>sw",
				fzf_open("grep_visual"),
				mode = "v",
				desc = "Selection (Root Dir)",
			},
			{
				"<leader>sW",
				fzf_open("grep_visual", { root = false }),
				mode = "v",
				desc = "Selection (cwd)",
			},
			{
				"<leader>uC",
				fzf_open("colorschemes"),
				desc = "Colorscheme with Preview",
			},
			{
				"<leader>ss",
				function()
					require("fzf-lua").lsp_document_symbols({
						regex_filter = extensions.fzf_symbols_filter,
					})
				end,
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				function()
					require("fzf-lua").lsp_live_workspace_symbols({
						regex_filter = extensions.fzf_symbols_filter,
					})
				end,
				desc = "Goto Symbol (Workspace)",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local Keys = require("plugins.lsp.keymaps").get()
            -- stylua: ignore
            vim.list_extend(Keys, {
                { "gd", "<cmd>FzfLua lsp_definitions     jump1=true ignore_current_line=true<cr>", desc = "Goto Definition",       has = "definition" },
                { "gr", "<cmd>FzfLua lsp_references      jump1=true ignore_current_line=true<cr>", desc = "References",            nowait = true },
                { "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
                { "gy", "<cmd>FzfLua lsp_typedefs        jump1=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
            })
		end,
	},
	{
		"folke/todo-comments.nvim",
		keys = {
			{
				"<leader>st",
				function()
					require("todo-comments.fzf").todo()
				end,
				desc = "Todo",
			},
			{
				"<leader>sT",
				function()
					require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
				end,
				desc = "Todo/Fix/Fixme",
			},
		},
	},

	-- which-key
	-- show the keys popup
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

	-- gitsigns
	{
		"lewis6991/gitsigns.nvim",
		event = "LazyFile",
		opts = {
			signs = {
				add = { text = "▏" },
				change = { text = "▏" },
				delete = { text = "▁" },
				topdelete = { text = "▁" },
				changedelete = { text = "▏" },
				untracked = { text = "▏" },
			},
			signs_staged = {
				add = { text = "▏" },
				change = { text = "▏" },
				delete = { text = "▁" },
				topdelete = { text = "▁" },
				changedelete = { text = "▏" },
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

	-- trouble
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

	-- todo-comments
	-- Finds and lists all of the TODO, HACK, BUG, etc comment
	-- in your project and loads them into a browsable list.
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "LazyFile",
		opts = {
			keywords = {
				FIX = {
					icon = "!", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = "!", color = "warning" },
				HACK = { icon = "!", color = "warning" },
				WARN = { icon = "!", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = "!", color = "hint", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = "!", color = "hint", alt = { "INFO" } },
				TEST = { icon = "!", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
		},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo Comment",
			},
			{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
			{
				"<leader>xT",
				"<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
				desc = "Todo/Fix/Fixme (Trouble)",
			},
		},
	},

	-- persistance.nvim
	-- session management
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

	-- completion plugin
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
					return Util.cmp.expand(snippet)
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
					enabled = true,
				},
				trigger = {
					show_in_snippet = false,
				},
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
			},
			signature = {
				enabled = true,
				window = {
					show_documentation = true,
				},
			},

			cmdline = {
				enabled = true,
				completion = {
					menu = { auto_show = true },
					list = {
						selection = { preselect = false },
					},
				},
			},

			sources = {
				-- adding any nvim-cmp sources here will enable them
				-- with blink.compat
				compat = {},
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- show at a higher priority than lsp
					},
				},
			},

			keymap = {
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
			opts.keymap["<Tab>"] = {
				require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
				Util.cmp.map({ "snippet_forward", "ai_accept" }),
				"fallback",
			}

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

	-- mini
	-- mini.pairs
	-- auto pair brackets and quotes
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			modes = { insert = true, command = false, terminal = false },
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
			mini.pairs(opts)
		end,
	},
	-- mini.comment
	-- toggle comment in normal and visual mode
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring()
						or vim.bo.commentstring
				end,
			},
			mappings = {
				comment_line = "<leader>/",
				comment_visual = "<leader>/",
			},
		},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
	-- ts-comments
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},
	-- mini.ai
	-- Better a and i motions
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
					g = mini.ai_buffer, -- buffer
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			Util.on_load("which-key.nvim", function()
				vim.schedule(function()
					mini.ai_whichkey(opts)
				end)
			end)
		end,
	},
	-- mini.surround
	-- add and remove surrounding brackets and quotes
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

	-- undotree
	{
		"mbbill/undotree",
		keys = {
			{
				"<leader>uu",
				"<cmd> UndotreeToggle <CR>",
				desc = " undotree",
			},
		},
		cmd = "UndotreeToggle",
		config = function()
			vim.g.undotree_SplitWidth = 50
			vim.g.undotree_SetFocusWhenToggle = 1
		end,
	},

	-- harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		opts = {
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
			settings = {
				save_on_toggle = true,
			},
		},
		keys = function()
			local keys = {
				{
					"<leader>ma",
					function()
						require("harpoon"):list():add()
					end,
					desc = "Harpoon File",
				},
				{
					"<leader>fb",
					function()
						local harpoon = require("harpoon")
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Harpoon Quick Menu",
				},
			}

			for i = 1, 5 do
				table.insert(keys, {
					"<leader>" .. i,
					function()
						require("harpoon"):list():select(i)
					end,
					desc = "Harpoon to File " .. i,
				})
			end
			return keys
		end,
		config = function(_, opts)
			local harpoon = require("harpoon")
			local harpoon_extensions = require("harpoon.extensions")

			harpoon.setup(opts)

			harpoon:extend(harpoon_extensions.builtins.navigate_with_number())
			harpoon:extend(extensions.harpoon_navigate_in_windows())
		end,
	},

	-- oil.nvim
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			keymaps = {
				["<C-v>"] = { "actions.select", opts = { vertical = true } },
				["<C-s>"] = { "actions.select", opts = { horizontal = true } },
				["<C-h>"] = false,
				["<C-l>"] = false,
			},
			view_options = {
				show_hidden = true,
			},
		},
		keys = {
			{
				"<leader>e",
				function()
					extensions.oil_Ex()
				end,
				desc = "Oil: Ex",
			},
			{
				"<leader>r",
				function()
					extensions.oil_Rex()
				end,
				desc = "Oil: Rex",
			},
		},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
	},

	-- debug adapter
	{
		"mfussenegger/nvim-dap",
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
			"nvim-neotest/nvim-nio",
		},

		keys = {
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Run/Continue",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dP",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug Nearest",
			},
		},
		opts = function(_, opts)
			local dap = require("dap")

			-- this provider is so we can put launch.json files in .dap.json
			dap.providers.configs["_.root.dap.json"] = function()
				local root = Util.root()
				local path = root .. "/.dap.json"
				local ok, configs = pcall(require("dap.ext.vscode").getconfigs, path)
				return ok and configs or {}
			end

			-- this is a hook that allows as to use string args in .dap.json
			-- it's useful if you want to read a single input and accept multiple args
			-- as the config expects a list of args instead of a single string
			---@class config
			---@field args string|string[]
			dap.listeners.on_config["_.root.dap.json"] = function(config)
				local _config = vim.deepcopy(config)
				-- if _config has property args and it's a string, split it
				if _config.args and type(_config.args) == "string" then
					---@diagnostic disable-next-line: param-type-mismatch
					_config.args = require("dap.utils").splitstr(_config.args)
				end
				return _config
			end
		end,
		config = function()
			-- load mason-nvim-dap here, after all adapters have been setup
			if Util.has("mason-nvim-dap.nvim") then
				require("mason-nvim-dap").setup(Util.opts("mason-nvim-dap.nvim"))
			end

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(require("config").icons.dap) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			-- setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
		end,
	},
	-- fancy UI for the debugger
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
        -- stylua: ignore
        keys = {
            { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
            { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
        },
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
		end,
	},
	-- mason.nvim integration
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {
				chrome = function(config)
					config.configurations = {}

					require("mason-nvim-dap").default_setup(config)
				end,
				codelldb = function(config)
					config.configurations = {}

					require("mason-nvim-dap").default_setup(config)
				end,
			},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
			},
		},
		-- mason-nvim-dap is loaded when nvim-dap loads
		config = function() end,
	},

	-- Treesitter is a new parser generator tool that we can
	-- use in Neovim to power faster and more accurate
	-- syntax highlighting.
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "LazyFile", "VeryLazy" },
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treesitter** module to be loaded in time.
			-- Luckily, the only things that those plugins need are the custom queries, which we make available
			-- during startup.
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts_extend = { "ensure_installed" },
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
				"zig",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				opts.ensure_installed = Util.dedup(opts.ensure_installed)
			end
			vim.treesitter.language.register("bash", "zsh")
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		enabled = true,
		config = function()
			-- If treesitter is already loaded, we need to run config again for textobjects
			if Util.is_loaded("nvim-treesitter") then
				local opts = Util.opts("nvim-treesitter")
				require("nvim-treesitter.configs").setup({ textobjects = opts.textobjects })
			end

			-- When in diff mode, we want to use the default
			-- vim text objects c & C instead of the treesitter ones.
			local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
			local configs = require("nvim-treesitter.configs")
			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
							for key, query in pairs(config or {}) do
								if q == query and key:find("[%]%[][cC]") then
									vim.cmd("normal! " .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "LazyFile",
		opts = function()
			local tsc = require("treesitter-context")
			Snacks.toggle({
				name = "Treesitter Context",
				get = tsc.enabled,
				set = function(state)
					if state then
						tsc.enable()
					else
						tsc.disable()
					end
				end,
			}):map("<leader>ut")
			return { mode = "cursor", max_lines = 3 }
		end,
	},

	-- better quickfix
	{
		"stevearc/quicker.nvim",
		event = "FileType qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			opts = {
				number = true,
				relativenumber = true,
			},
			constrain_cursor = false,
		},
	},

	-- Automatically add closing tags for HTML and JSX
	{
		"windwp/nvim-ts-autotag",
		event = "LazyFile",
		opts = {},
	},

	-- lazydev
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
