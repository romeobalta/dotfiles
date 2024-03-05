local codelldb = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension"

local config = function()
	local on_attach = require("plugins.configs.lspconfig").on_attach
	local capabilities = require("plugins.configs.lspconfig").capabilities

	local codelldb_path = codelldb .. "adapter/codelldb"
	local liblldb_path = codelldb .. "lldb/lib/liblldb.dylib"

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
