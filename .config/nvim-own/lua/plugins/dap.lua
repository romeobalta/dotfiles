return {
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

			-- zig defaults
			for _, lang in ipairs({ "zig" }) do
				dap.configurations[lang] = {
					{
						type = "codelldb",
						request = "launch",
						name = "LLDB: Launch with args",
						program = function()
							return require("dap.utils").pick_file({
								executables = true,
								path = Util.root(),
								filter = function(filepath)
									-- look only for paths in the cwd with zig-out in them
									return vim.fn.match(filepath, "zig-out") ~= -1
										and vim.fn.match(filepath, Util.root()) ~= -1
								end,
							})
						end,
						args = function()
							local args = vim.fn.input("Arguments: ", "", "file") -- Read some args
							return args == "" and {} or require("dap.utils").splitstr(args)
						end,
						cwd = vim.fn.getcwd(),
					},
					{
						type = "codelldb",
						request = "attach",
						name = "LLDB: Attach to process",
						pid = function()
							return require("dap.utils").pick_process({
								filter = function(proc)
									return vim.fn.match(proc.name, "zig-out") ~= -1
								end,
							})
						end,
						cwd = vim.fn.getcwd(),
					},
				}
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
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
			},
		},
		-- mason-nvim-dap is loaded when nvim-dap loads
		config = function() end,
	},
}
