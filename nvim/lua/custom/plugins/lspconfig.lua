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
	"taplo",
	"rust_analyzer",
}

local opts = {}

for _, lsp in ipairs(servers) do
	opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	if lsp == "rust_analyzer" then
		opts.settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		}

		require("rust-tools").setup({
			server = opts,
		})
		goto continue
	end

	if lsp == "cssls" then
		opts.settings = {
			css = {
				lint = {
					unknownAtRules = "ignore",
				},
			},
		}
	end

	lspconfig[lsp].setup(opts)
	::continue::
end
