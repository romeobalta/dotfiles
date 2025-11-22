return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "zig" } },
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				zls = {
					mason = false,

					settings = {
						zls = {
							semantic_tokens = "partial",
						},
					},
				},
			},
		},
	},

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- Ensure C/C++ debugger is installed
			"mason-org/mason.nvim",
			opts = { ensure_installed = { "codelldb" } },
		},
		opts = function()
			local dap = require("dap")
			if not dap.adapters["codelldb"] then
				require("dap").adapters["codelldb"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "codelldb",
						args = {
							"--port",
							"${port}",
						},
					},
				}
			end

			dap.configurations.zig = {
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
		end,
	},

	{
		"nvim-neotest/neotest",
		dependencies = {
			"lawrence-laz/neotest-zig",
		},
		opts = {
			adapters = {
				["neotest-zig"] = {
					dap = {
						adapter = "codelldb",
					},
				},
			},
		},
	},
}
