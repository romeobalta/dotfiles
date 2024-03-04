local keys = {
  {
    "gD",
    function()
      vim.lsp.buf.declaration()
    end,
    desc = "LSP declaration",
  },
  {
    "gd",
    function()
      vim.lsp.buf.definition()
    end,
    desc = "LSP definition",
  },
  {
    "K",
    function()
      vim.lsp.buf.hover()
    end,
    desc = "LSP hover",
  },
  {
    "gi",
    function()
      vim.lsp.buf.implementation()
    end,
    desc = "LSP implementation",
  },
  {
    "<leader>gs",
    function()
      vim.lsp.buf.signature_help()
    end,
    desc = "LSP signature help",
  },
  {
    "<leader>D",
    function()
      vim.lsp.buf.type_definition()
    end,
    desc = "LSP definition type",
  },
  {
    "<leader>ra",
    function()
      require("nvchad.renamer").open()
    end,
    desc = "LSP rename",
  },
  {
    "<leader>ca",
    function()
      vim.lsp.buf.code_action()
    end,
    desc = "LSP code action",
    mode = { "n", "v" }, -- Apply for both normal and visual mode
  },
  {
    "gr",
    function()
      vim.lsp.buf.references()
    end,
    desc = "LSP references",
  },
  {
    "<leader>f",
    function()
      vim.diagnostic.open_float({ border = "rounded" })
    end,
    desc = "Floating diagnostic",
  },
  {
    "d[",
    function()
      vim.diagnostic.goto_prev({ float = { border = "rounded" } })
    end,
    desc = "Goto prev",
  },
  {
    "d]",
    function()
      vim.diagnostic.goto_next({ float = { border = "rounded" } })
    end,
    desc = "Goto next",
  },
  {
    "<leader>q",
    function()
      vim.diagnostic.setloclist()
    end,
    desc = "Diagnostic setloclist",
  },
  {
    "<leader>wa",
    function()
      vim.lsp.buf.add_workspace_folder()
    end,
    desc = "Add workspace folder",
  },
  {
    "<leader>wr",
    function()
      vim.lsp.buf.remove_workspace_folder()
    end,
    desc = "Remove workspace folder",
  },
  {
    "<leader>wl",
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    desc = "List workspace folders",
  },
}

return {
  "neovim/nvim-lspconfig",
  keys = keys,
  dependencies = {
    "mason.nvim",
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup()
      end,
    },
    {
      "nvimtools/none-ls.nvim",
      dependencies = {
        "mason.nvim",
      },
      opts = function()
        local null_ls = require("null-ls")

        return {
          debug = true,
          sources = {
            -- webdev stuff
            null_ls.builtins.formatting.prettierd,

            -- Lua
            null_ls.builtins.formatting.stylua,

            -- Shell
            null_ls.builtins.formatting.shfmt,
          },
        }
      end,
      config = function(_, opts)
        local null_ls = require("null-ls")
        null_ls.setup(opts)

        vim.api.nvim_create_user_command("NullLsToggle", function()
          null_ls.toggle({})
        end, {})
      end,
    },
  },
  config = function()
    local M = {}
    local lspconfig = require("lspconfig")

    -- export on_attach & capabilities for custom lspconfigs

    M.on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      if client.server_capabilities.signatureHelpProvider then
        require("nvchad.signature").setup(client)
      end

      if client.name == "tsserver" then
        vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = bufnr, desc = "Organize Imports" })
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
      "lua_ls",
      "pylsp",
      "tailwindcss",
      "taplo",
      "tsserver",
      "eslint",

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
        opts.filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        }
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

      if lsp == "eslint" then
        opts.settings = {
          workingDirectories = { mode = "auto" },
        }
      end

      lspconfig[lsp].setup(opts)
    end
  end,
}
