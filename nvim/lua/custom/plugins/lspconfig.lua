local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local servers = {
  "html",
  "cssls",
  "clangd",
  "jsonls",
  "tsserver",
  "astro",
  "cmake",
  "dotls",
  "gopls",
  "jsonls",
  "pylsp",
  "tailwindcss",
  "yamlls",
  "bashls",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
