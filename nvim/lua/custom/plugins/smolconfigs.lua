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

  local options = {
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
    },
  }

  print(options)

  return options
end

return M
