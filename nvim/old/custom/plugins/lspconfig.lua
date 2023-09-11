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
}

local opts = {}

for _, lsp in ipairs(servers) do
	opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	-- if lsp == "rust_analyzer" then
	-- 	opts.settings = {
	-- 		["rust-analyzer"] = {
	-- 			checkOnSave = {
	-- 				command = "clippy",
	-- 			},
 --        cargo = {
 --          allFeatures = true,
 --        },
	-- 		},
	-- 	}
 --    opts.filetypes = { "rust" }
 --    opts.root_dir = lspconfig.util.root_pattern("Cargo.toml")
 --  end

	if lsp == "cssls" then
		opts.settings = {
			css = {
				lint = {
					unknownAtRules = "ignore",
				},
			},
		}
	end

	if lsp == "tailwindcss" then
		require("telescope").load_extension("tailiscope")
		vim.keymap.set("n", "<leader>fw", "<cmd>Telescope tailiscope<CR>")
	end

	lspconfig[lsp].setup(opts)
	-- ::continue::
end
