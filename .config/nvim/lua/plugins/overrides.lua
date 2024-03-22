return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvim-pack/nvim-spectre",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      {
        "<leader>s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<leader>S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
    keys = {
      { "<leader>sna", mode = { "n" }, false },
      { "<leader>snd", mode = { "n" }, false },
      { "<leader>snh", mode = { "n" }, false },
      { "<leader>snl", mode = { "n" }, false },
    },
  },
}
