local newKeys = {
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
      -- codelens = { enabled = true },
      inlay_hints = { enabled = false },
      -- format = { timeout_ms = 5000 },
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
