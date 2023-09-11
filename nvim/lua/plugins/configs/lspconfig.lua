dofile(vim.g.base46_cache .. "lsp")
require("nvchad.lsp")

local M = {}
local utils = require("core.utils")
local lspconfig = require("lspconfig")

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	utils.load_mappings("lspconfig", { buffer = bufnr })

	if client.server_capabilities.signatureHelpProvider then
		require("nvchad.signature").setup(client)
	end

	if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

local servers = {
	"bashls",
	"cssls",
	"dotls",
	"html",
	"jsonls",
	"jsonls",
	"lua_ls",
	"pylsp",
	"tailwindcss",
	"taplo",
	"tsserver",
	"yamlls",

	-- TODO: maybe we want to reenable these later
	-- "astro",
	-- "clangd",
	-- "cmake",
	-- "gopls",
}

local opts = {}

for _, lsp in ipairs(servers) do
	opts = {
		on_attach = M.on_attach,
		capabilities = M.capabilities,
	}

	if lsp == "cssls" then
		opts.settings = {
			css = {
				lint = {
					unknownAtRules = "ignore",
				},
			},
		}

		opts.filetypes = { "css", "scss", "less", "sass" }
	end

	if lsp == "bashls" then
		opts.filetypes = { "sh", "zsh" }
	end

	if lsp == "jsonls" then
		opts.filetypes = { "json", "jsonc" }
	end

	if lsp == "pylsp" then
		opts.filetypes = { "python" }
	end

	if lsp == "tsserver" then
		opts.filetypes =
			{ "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
	end

	if lsp == "yamlls" then
		opts.filetypes = { "yaml" }
	end

  if lsp == "dotls" then
    opts.filetypes = { "dot" }
  end

  if lsp == "taplo" then
    opts.filetypes = { "toml" }
  end

  if lsp == "html" then
    opts.filetypes = { "html" }
  end

	if lsp == "tailwindcss" then
		require("telescope").load_extension("tailiscope")
		vim.keymap.set("n", "<leader>fw", "<cmd>Telescope tailiscope<CR>")

		opts.filetypes = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" }
		opts.root_dir = lspconfig.util.root_pattern("tailwind.config.js", "postcss.config.js", "package.json", ".git")
	end

	if lsp == "lua_ls" then
		opts.settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						[vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
						[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		}

		opts.filetypes = { "lua" }
	end

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

	lspconfig[lsp].setup(opts)
end

return M
