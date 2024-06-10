local newKeys = {
  {
    "<leader>f",
    function()
      vim.diagnostic.open_float({ border = "rounded" })
    end,
    desc = "Floating diagnostic",
  },
  {
    "[d",
    function()
      vim.diagnostic.goto_prev({ float = { border = "rounded" } })
    end,
    desc = "Goto prev diagnostic",
  },
  {
    "]d",
    function()
      vim.diagnostic.goto_next({ float = { border = "rounded" } })
    end,
    desc = "Goto next diagnostic",
  },
  {
    "<leader>cwa",
    function()
      vim.lsp.buf.add_workspace_folder()
    end,
    desc = "Add workspace folder",
  },
  {
    "<leader>cwr",
    function()
      vim.lsp.buf.remove_workspace_folder()
    end,
    desc = "Remove workspace folder",
  },
  {
    "<leader>cwl",
    function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    desc = "List workspace folders",
  },

  -- disable
  { "<c-k>", false, mode = "i" },
}

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      for _, newKey in ipairs(newKeys) do
        keys[#keys + 1] = newKey
      end
    end,
    keys = {},
    opts = {
      format = { timeout_ms = 5000 },
      servers = {
        mdx_analyzer = {},
      },
    },
  },
  {
    {
      "mfussenegger/nvim-lint",
      opts = {
        linters = {
          markdownlint = {
            args = { "--config", "~/.markdownlint.jsonc", "--" },
          },
        },
      },
    },
  },
}
