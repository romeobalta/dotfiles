local dap = require("dap")
local codelldb = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension"

dap.adapters.lldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = codelldb .. "/adapter/codelldb",
		args = { "--port", "${port}" },
	},
}

dap.configurations.rust = {
	{
		name = "Debug",
		type = "lldb",
		request = "launch",
		program = function()
			local cwd = vim.fn.getcwd()
			local package_name = cwd:match("([^/]+)$")

			return cwd .. "/target/debug/" .. package_name
		end,
	},
}

print("Loaded dap.lua")
