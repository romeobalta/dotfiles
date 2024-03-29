return {
  "romeobalta/harpoon",
  dependencies = {
    "folke/tokyonight.nvim",
  },
  keys = {
    {
      "<leader>ma",
      function()
        require("harpoon.mark").add_file()
        vim.cmd.redrawtabline()
      end,
      desc = " add mark",
    },
    {
      "<leader>fb",
      function()
        require("harpoon.ui").toggle_quick_menu()
        vim.cmd.redrawtabline()
      end,
      desc = " list mark",
    },
    {
      "<Tab>",
      function()
        require("harpoon.ui").nav_next()
      end,
      desc = " next mark",
    },
    {
      "<S-Tab>",
      function()
        require("harpoon.ui").nav_prev()
      end,
      desc = " prev mark",
    },
    {
      "<leader>1",
      function()
        require("harpoon.ui").nav_file(1, { check_windows = true })
      end,
      desc = " go to mark 1",
    },
    {
      "<leader>2",
      function()
        require("harpoon.ui").nav_file(2, { check_windows = true })
      end,
      desc = " go to mark 2",
    },
    {
      "<leader>3",
      function()
        require("harpoon.ui").nav_file(3, { check_windows = true })
      end,
      desc = " go to mark 3",
    },
    {
      "<leader>4",
      function()
        require("harpoon.ui").nav_file(4, { check_windows = true })
      end,
      desc = " go to mark 4",
    },
  },
  lazy = false,
  opts = {
    excluded_filetypes = { "dashboard", "NvimTree", "terminal", "harpoon" },
    tabline = true,
  },
  config = function(_, opts)
    require("harpoon").setup(opts)
  end,
}
