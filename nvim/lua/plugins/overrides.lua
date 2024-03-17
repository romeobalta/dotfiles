return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {

    "nvim-neo-tree/neo-tree.nvim",
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
      {
        "q",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "Q",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
  {
    "folke/persistence.nvim",
    enabled = false,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
}
