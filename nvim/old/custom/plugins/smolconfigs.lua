local M = {}

M.autotag = function()
	local present, autotag = pcall(require, "nvim-ts-autotag")

	if present then
		autotag.setup()
	end
end

M.shade = function()
	local present, shade = pcall(require, "shade")

	if not present then
		return
	end

	shade.setup({
		overlay_opacity = 50,
		opacity_step = 1,
		exclude_filetypes = { "NvimTree" },
	})
end

M.autosave = function()
	local present, autosave = pcall(require, "autosave")

	if present then
		autosave.setup({
			enabled = true,
			events = { "InsertLeave", "TextChanged" },
			conditions = {
				exists = true,
				modifiable = true,
			},
			debounce_delay = 135,
		})
	end
end

M.rust_tools = function()
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

return M
