local function pick(kind)
	return function()
		local actions = require("CopilotChat.actions")
		local items = actions[kind .. "_actions"]()
		if not items then
			Util.warn("No " .. kind .. " found on the current line")
			return
		end
		require("CopilotChat.integrations.fzflua").pick(items)
	end
end

return {
	-- copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "BufReadPost",
		opts = {
			suggestion = {
				enabled = false,
				auto_trigger = true,
				hide_during_completion = true,
				keymap = {
					accept = false, -- handled by nvim-cmp / blink.cmp
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
			panel = { enabled = false },
			filetypes = {
				markdown = true,
				help = true,
			},
		},
	},

	-- hook into cmp and lsp
	{
		"zbirenbaum/copilot.lua",
		opts = function()
			Util.cmp.actions.ai_accept = function()
				if require("copilot.suggestion").is_visible() then
					Util.create_undo()
					require("copilot.suggestion").accept()
					return true
				end
			end

			Util.lsp.register_client("copilot", "")
		end,
	},

	{
		"saghen/blink.cmp",
		dependencies = { "giuxtaposition/blink-cmp-copilot" },
		opts = {
			sources = {
				default = { "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						kind = "Copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
		},
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		cmd = "CopilotChat",
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				auto_insert_mode = true,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				window = {
					width = 0.4,
				},
				mappings = {
					reset = {
						normal = "<C-x>",
						insert = "<C-x>",
					},
				},
			}
		end,
		keys = {
			{ "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			-- Show prompts actions with telescope
			{ "<leader>ap", pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
			{
				"<leader>am",
				function()
					require("snacks.notify").info("Using model: " .. require("CopilotChat").config.model)
				end,
				desc = "Select Model (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>a?",
				function()
					return require("CopilotChat").select_model()
				end,
				desc = "Select Model (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>at",
				function()
					local copilot = require("copilot.command")
					local status = require("copilot.client").is_disabled()
					local notify = require("snacks.notify")
					if status then
						notify.notify("Copilot is being enabled")
						copilot.enable()
					else
						notify.notify("Copilot is being disabled")
						copilot.disable()
					end
				end,
				desc = "Toggle Copilot",
			},
		},
		config = function(_, opts)
			local chat = require("CopilotChat")

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			chat.setup(opts)
		end,
	},
}
