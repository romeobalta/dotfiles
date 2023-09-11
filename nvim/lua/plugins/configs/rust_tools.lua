local config = function()
	local on_attach = require("plugins.configs.lspconfig").on_attach
	local capabilities = require("plugins.configs.lspconfig").capabilities

	local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.2/"
	local codelldb_path = extension_path .. "adapter/codelldb"
	local liblldb_path = extension_path .. "lldb/lib/liblldb"
	local this_os = vim.loop.os_uname().sysname

	-- The path in windows is different
	-- The liblldb extension is .so for linux and .dylib for macOS
	liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")

	local options = {
		server = {
			on_attach = on_attach,
			capabilities = capabilities,
		},

		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
		},
	}

	return options
end

return config
