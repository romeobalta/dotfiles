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
      inlay_hints = { enabled = false },
      serers = {
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
