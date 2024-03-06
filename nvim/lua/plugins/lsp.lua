local newKeys = {
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
  { "<leader>ra", vim.lsp.buf.rename, desc = "Rename", has = "rename" },

  -- disable
  { "<leader>cr", false },
}

return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    for _, newKey in ipairs(newKeys) do
      keys[#keys + 1] = newKey
    end
  end,
  opts = {
    format = { timeout_ms = 5000 },
  },
}
